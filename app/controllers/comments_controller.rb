class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_board, only: [:create]
  before_action :require_login, only: %i[create update destroy]

  def create
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = I18n.t('comments.create_success')
      redirect_to @board
    else
      flash[:alert] = I18n.t('comments.create_failure')
      redirect_to @board
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      flash[:notice] = t('comments.create_success')
      redirect_to @comment.board
    else
      flash[:alert] = t('comments.update_failure')
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = I18n.t('comments.destroy_success')
    else
      flash[:alert] = I18n.t('comments.destroy_failure')
    end
    redirect_to @comment.board
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_board
    @board = Board.find(params[:board_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
