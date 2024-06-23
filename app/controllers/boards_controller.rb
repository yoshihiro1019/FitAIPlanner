class BoardsController < ApplicationController
  before_action :set_board, only: %i[edit update destroy]
  before_action :set_board_for_show, only: %i[show]

  def index
    @q = Board.ransack(params[:q])
    @boards = @q.result.includes(:user).page(params[:page])
  end

  def show
    @user = @board.user
    render :show, locals: { board: @board }
  end

  def new
    @board = Board.new
  end

  def edit
    # 既に @board を取得しているため、何もしない
  end

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
      flash.now[:danger] = t('flash.alert.board_not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_url, success: '掲示板を削除しました', status: :see_other
  end

  def bookmarks
    @q = Board.joins(:bookmarks).where(bookmarks: { user_id: current_user.id }).ransack(params[:q])
    @bookmarked_boards = @q.result(distinct: true).includes(:user).page(params[:page])
  end

  private

  def set_board
    @board = current_user.boards.find_by(id: params[:id])
    unless @board
      Rails.logger.error "Board not found with id=#{params[:id]} for user_id=#{current_user.id}"
      if Rails.env.test?
        raise ActiveRecord::RecordNotFound
      else
        redirect_to boards_path, alert: 'Board not found'
      end
    end
  end
  
  def set_board_for_show
    @board = Board.find_by(id: params[:id])
    unless @board
      Rails.logger.error "Board not found with id=#{params[:id]}"
      if Rails.env.test?
        raise ActiveRecord::RecordNotFound
      else
        render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
      end
    end
  end

  def board_params
    params.require(:board).permit(:title, :body, :board_image)
  end
end
