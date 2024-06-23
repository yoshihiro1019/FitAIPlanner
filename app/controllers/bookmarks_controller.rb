class BookmarksController < ApplicationController
  before_action :require_login

  def index
    @q = Board.joins(:bookmarks).where(bookmarks: { user_id: current_user.id }).ransack(params[:q])
    @bookmarked_boards = @q.result(distinct: true).includes(:user).page(params[:page])
  end

  def create
    @board = Board.find(params[:board_id])
    current_user.bookmarks.create!(board: @board)
  end

  def destroy
    @board = Board.find(params[:board_id])
    bookmark = current_user.bookmarks.find_by(board: @board)
    bookmark&.destroy
    redirect_to @board
  end
end
