class BookmarksController < ApplicationController
  before_action :require_login

  def create
    board = Board.find(params[:board_id])
    current_user.bookmark(board)
    redirect_to boards_path, notice: 'ブックマークしました'
  end

  def destroy
    board = Board.find(params[:board_id])
    current_user.unbookmark(board)
    redirect_to boards_path, notice: 'ブックマークを外しました'
  end

  def index
    @bookmarks = current_user.bookmarks.includes(:board)
    if params[:search].present?
      @bookmarks = @bookmarks.joins(:board).where('boards.title LIKE ?', "%#{params[:search]}%")
    end
  end
end
