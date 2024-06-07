class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_board, only: [:create]

  def create
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = 'コメントを作成しました'
      redirect_to @board
    else
      flash[:alert] = 'コメントを作成出来ませんでした'
      redirect_to @board
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      flash[:notice] = 'コメントを更新しました'
      redirect_to @comment.board
    else
      flash[:alert] = 'コメントを更新出来ませんでした'
      render :edit
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = 'コメントを削除しました'
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
