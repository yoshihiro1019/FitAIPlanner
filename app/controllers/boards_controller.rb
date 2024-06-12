class BoardsController < ApplicationController
  before_action :set_board, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

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
    authorize_user!
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

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    respond_to do |format|
      format.html { redirect_to boards_url, success: '投稿が削除されました。' }
      format.json { head :no_content }
    end
  end

  def update
    if @board.update(board_params)
      flash[:success] = t('flash.success.board_updated')
      redirect_to @board
    else
      flash.now[:alert] = t('flash.success.board_updated')
      render :edit
    end
  end

  private

  def set_board
    @board = Board.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to boards_path, alert: t('flash.alert.not_found')
  end

  def board_params
    params.require(:board).permit(:title, :body, :board_image)
  end

  def authorize_user!
    return if @board.user != current_user

    raise ActiveRecord::RecordNotFound
  end
end
