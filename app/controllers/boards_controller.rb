class BoardsController < ApplicationController
  def index
    @boards = Board.includes(:user)
  end
  def new
    @board = Board.new
  end
end
