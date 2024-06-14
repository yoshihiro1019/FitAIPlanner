class BookmarksController < ApplicationController
  before_action :require_login

  def create
    board = Board.find(params[:board_id])
    current_user.bookmarks.create!(board:)
    flash[:success] = t('notices.bookmark_created')
    redirect_to boards_path
  end

  def destroy
    board = Board.find(params[:board_id])
    current_user.bookmarks.find_by(board:).destroy
    flash[:success] = t('notices.bookmark_destroyed')
    redirect_to boards_path
  end

  def index
    @bookmarks = current_user.bookmarks.includes(:board)
    if params[:search].present?
      @bookmarks = @bookmarks.joins(:board).where('boards.title LIKE ?', "%#{params[:search]}%")
    end
  end
end
