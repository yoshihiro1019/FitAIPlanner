require 'rails_helper'

RSpec.describe 'ブックマーク', type: :system do
  let(:user) { create(:user) }
  let!(:board) { create(:board) }
  let!(:bookmark) { create(:bookmark, user: user) }

  it 'ブックマークができること' do
    login_as(user)
    visit '/boards'
    find("#bookmark-button-for-board-#{board.id}").click
    expect(current_path).to eq('/boards'), 'ブックマーク作成後に、掲示板一覧画面が表示されていません'
    expect(page).to have_content('ブックマークしました'), 'フラッシュメッセージ「ブックマークしました」が表示されていません'
  end

  it 'ブックマークを外せること' do
    login_as(user)
    visit '/boards'
    # ブックマークを外す
    find("#unbookmark-button-for-board-#{bookmark.board.id}").click
    expect(current_path).to eq('/boards'), 'ブックマーク解除後に、掲示板一覧画面が表示されていません'
    expect(page).to have_content('ブックマークを外しました'), 'フラッシュメッセージ「ブックマークを外しました」が表示されていません'
  end
end
