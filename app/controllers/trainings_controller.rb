require 'net/http'
require 'uri'
require 'json'
require 'googleauth'  # OAuth 2.0の認証に必要なライブラリを追加

SCOPE = ['https://www.googleapis.com/auth/cloud-platform'].freeze  # OAuth 2.0のスコープを定義


class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :destroy]
    
    def index
      @trainings = current_user.trainings
    end

    def edit
      @training = Training.find(params[:id]) 
    end

    def get_google_oauth_token
      # サービスアカウントキーから認証情報を作成
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open('config/superb-receiver-353609-7f91a076035f.json'), # サービスアカウントキーのJSONファイル
        scope: SCOPE
      )
      authorizer.fetch_access_token!['access_token']
    end
    

    def gemini_suggestions
      # OAuth 2.0トークンを取得
      access_token = get_google_oauth_token
      
      # トークンが取得できなかった場合の処理
      if access_token.nil?
        Rails.logger.error "トークンの取得に失敗しました。"
        @training_plan = "エラーが発生しました。トークンの取得に失敗しました。"
        render 'trainings/gemini_training_plan' and return
      end
    
      # 正しいエンドポイントを指定
      uri = URI.parse("https://generativelanguage.googleapis.com/v1beta/models/text-bison-001:generateText")
      
      # デバッグ: URI確認
      Rails.logger.debug "APIエンドポイントURI: #{uri}"
      
      # POSTリクエストを作成
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{access_token}"  # OAuth 2.0アクセストークンを設定
      request.content_type = "application/json"
      
      # デバッグ: Authorizationヘッダー確認
      Rails.logger.debug "Authorization Header: #{request['Authorization']}"
      
      # リクエストのボディ（パラメータ）を設定
      request.body = {
        "prompt" => {
          "text" => "Create a personalized workout plan for someone looking to improve their cardio fitness."
        }
      }.to_json
      
      # デバッグ: リクエストボディ確認
      Rails.logger.debug "リクエストボディ: #{request.body}"
      
      begin
        # APIリクエストを実行
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end
    
        # デバッグ: レスポンスステータスと内容確認
        Rails.logger.debug "レスポンスステータス: #{response.code}"
        Rails.logger.debug "レスポンスボディ: #{response.body}"
        
        # レスポンスが成功したかどうかを確認
        if response.is_a?(Net::HTTPSuccess)
          json_response = JSON.parse(response.body)
          Rails.logger.debug "パースされたレスポンス: #{json_response}"
          
          # レスポンスからトレーニングプランを取得
          @training_plan = json_response.dig('candidates', 0, 'output') || "トレーニングプランが見つかりませんでした。"
        else
          # エラーメッセージがある場合はそれを設定
          @training_plan = "エラーが発生しました。APIからデータを取得できませんでした。"
          Rails.logger.error "APIリクエストエラー: #{response.code} - #{response.message}"
        end
    
      rescue StandardError => e
        # ネットワークエラーやJSONパースエラーのキャッチ
        Rails.logger.error "APIリクエスト中にエラーが発生しました: #{e.message}"
        @training_plan = "エラーが発生しました。APIリクエスト中に問題が発生しました。"
      end
    
      # ビューをレンダリング
      render 'trainings/gemini_training_plan'
    end
    
    
    def new_training_suggestion
      render 'trainings/new_training_suggestion'
    end
    
    def create_training_suggestion
      # ユーザーの入力を受け取る
      goal = params[:goal]
      time = params[:time]
      level = params[:level]
      equipment = params[:equipment]
  
      # シンプルなロジックでトレーニング提案を作成
      @training_plan = "目標: #{goal}\n時間: #{time}分\n強度: #{level}\n器具: #{equipment}"
  
      # 提案を表示するビューにデータを渡す
      render 'trainings/show_training_suggestion'
    end
    def show
      @training = Training.find(params[:id])
    end
    # トレーニング記録の更新
    def update
      @training = Training.find(params[:id])
      if @training.update(training_params)
        redirect_to @training, notice: 'トレーニングが更新されました。'    
      else
        flash.now[:danger] = '更新に失敗しました'
        render :edit
      end
    end

    def destroy
      @training = Training.find(params[:id])
      @training.destroy
      flash[:success] = "トレーニングが削除されました"
      redirect_to trainings_path, status: :see_other
    end
  
    def new
      @training = Training.new
      @training_names = ['筋トレ', 'ランニング', 'サイクリング']
      @training_descriptions = ['筋トレ', 'ランニング', 'サイクリング'] # 初期状態では空にしておく
      @training_parts = ['胸', '背中', '脚', '肩', '腕', 'お尻', '腹筋']
    end

    def suggestions
      prompt = "Create a personalized workout plan for someone looking to improve their cardio fitness."
  
      client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  
      # AIにリクエストを送信して、トレーニングプランを取得
      response = client.completions.create(
        model: 'text-davinci-003',
        prompt: prompt,
        max_tokens: 150
      )
  
      # 取得したトレーニングプランを変数に格納
      @training_plan = response['choices'][0]['text']
  
      # 結果を表示するビューをレンダリング
      render 'suggestions'
    end
  
    def create
      @training = current_user.trainings.new(training_params)
      if @training.save
        flash[:success] = "トレーニングを記録しました"
        redirect_to trainings_path
      else
        render :new
      end
    end
  
    private

    def set_training
      @training = current_user.trainings.find(params[:id])
    end
  
    def training_params
      params.require(:training).permit(:title, :description, :date, :part, :sets, :reps)
    end

    def get_training_suggestion(goal, level, equipment, time)
      # API呼び出しまたはAIモデルの呼び出し
      # ここでトレーニングプランを生成
      return "提案されたトレーニングプラン"
    end
end
  