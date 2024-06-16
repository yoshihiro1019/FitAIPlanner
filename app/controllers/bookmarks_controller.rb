class BookmarksController < ApplicationController
  before_action :require_login

  def create
    @board = Board.find(params[:board_id])
    current_user.bookmarks.create!(board: @board)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to boards_path, status: :see_other }
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    bookmark = current_user.bookmarks.find_by(board: @board)
    bookmark&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to boards_path, status: :see_other }
    end
  end

  def index
    @bookmarks = current_user.bookmarks.includes(:board)
  end
end
