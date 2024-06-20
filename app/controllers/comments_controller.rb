class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_board, only: [:create]
  before_action :require_login, only: %i[create update destroy]
  add_flash_types :success, :danger

  def create
    @comment = build_comment
    if @comment.save
      handle_success
    else
      handle_failure
    end
  end

  def edit
    # editアクションの実装
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream { render 'boards/comments/update' }
        format.html do
          flash[:success] = I18n.t('comments.update_success')
          redirect_to board_path(@board)
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('edit_comment_form', partial: 'boards/comments/form', locals: { board: @board, comment: @comment }) }
        format.html do
          flash[:danger] = I18n.t('comments.update_failure')
          redirect_to board_path(@board)
        end
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("comment-#{@comment.id}") }
      format.html do
        flash[:notice] = I18n.t('comments.destroy_success')
        redirect_to board_path(@comment.board)
      end
    end
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
  


def build_comment
comment = @board.comments.build(comment_params)
comment.user = current_user
comment
end

def handle_success
respond_to do |format|
  format.turbo_stream { render 'boards/comments/create' }
  format.html do
    flash[:success] = I18n.t('comments.create_success')
    redirect_to board_path(@board)
  end
end
end

def handle_failure
respond_to do |format|
  format.turbo_stream { render turbo_stream: turbo_stream.replace('new_comment_form', partial: 'boards/comments/form', locals: { board: @board, comment: @comment }) }
  format.html do
    flash[:danger] = I18n.t('comments.create_failure')
    redirect_to board_path(@board)
  end
end
end
end
