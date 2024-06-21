class BookmarksController < ApplicationController
  before_action :require_login

  def create
    @board = Board.find(params[:board_id])
    current_user.bookmarks.create!(board: @board)
  end

  def destroy
    @board = Board.find(params[:board_id])
    bookmark = current_user.bookmarks.find_by(board: @board)
    bookmark&.destroy
  end

  def index
    @bookmarks = current_user.bookmarks.includes(:board).page(params[:page])
  end
end
