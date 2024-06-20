class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_board, only: [:create]
  before_action :require_login, only: %i[create update destroy]
  add_flash_types :success, :danger

  def create
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html do
          flash[:success] = I18n.t('comments.create_success')
          redirect_to @board
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment-form", partial: "boards/comments/form", locals: { board: @board, comment: @comment }) }
        format.html do
          flash[:danger] = I18n.t('comments.create_failure')
          redirect_to @board
        end
      end
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html do
          flash[:notice] = I18n.t('comments.update_success')
          redirect_to @comment.board
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("edit_comment_form", partial: "boards/comments/form", locals: { board: @board, comment: @comment }) }
        format.html do
          flash[:danger] = I18n.t('comments.update_failure')
          render :edit
        end
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("comment-#{@comment.id}") }
        format.html do
          flash[:notice] = I18n.t('comments.destroy_success')
          redirect_to @comment.board
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:danger] = I18n.t('comments.destroy_failure')
          redirect_to @comment.board
        end
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
end
