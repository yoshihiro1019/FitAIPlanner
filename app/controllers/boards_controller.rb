class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  
  def index
    @boards = Board.includes(:user)
  end

  def show
    # URLパラメーターから掲示板のIDを取得
    @board = Board.find(params[:id])
    @user = @board.user
  end

  def new
    @board = Board.new
  end

  def edit
    @board = Board.find(params[:id])
  end


  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      update_board_image if params[:board][:board_image].present?
      redirect_to boards_path, success: t('defaults.flash_message.created', item: Board.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def set_board
    @board = Board.find(params[:id])
  end

  

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    respond_to do |format|
      format.html { redirect_to boards_url, notice: '投稿が削除されました。' }
      format.json { head :no_content }
    end
  end

  def update
    if @board.update(board_params)
      redirect_to @board, notice: '掲示板を更新しました'
    else
      flash.now[:alert] = '掲示板を更新出来ませんでした。'
      render :edit
    end
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :body, :board_image)
  end

  def authorize_user!
    @board = Board.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @board.user == current_user
  end
end
