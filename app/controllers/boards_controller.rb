class BoardsController < ApplicationController
  before_action :set_board, only: %i[edit update destroy]
  before_action :set_board_for_show, only: %i[show]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @boards = Board.includes(:user)
  end

  def show
    @user = @board.user
    render :show, locals: { board: @board }
  end

  def new
    @board = Board.new
  end

  def edit; end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to boards_path, success: t('defaults.flash_message.created', item: Board.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @board.update(board_params)
      flash[:success] = t('flash.success.board_updated')
      redirect_to @board
    else
      flash.now[:alert] = t('flash.alert.board_not_updated')
      render :edit
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_url, success: '投稿が削除されました。'
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def set_board_for_show
    @board = Board.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to boards_path, alert: t('flash.alert.not_found')
  end

  def board_params
    params.require(:board).permit(:title, :body, :board_image)
  end

  def authorize_user!
    raise ActiveRecord::RecordNotFound unless @board.user == current_user
  end
end
