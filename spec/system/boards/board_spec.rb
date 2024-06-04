require 'rails_helper'

RSpec.describe '掲示板', type: :system do
  let(:user) { create(:user) }
  let(:board) { create(:board, user: user) }

  describe '掲示板のCRUD' do
    describe '掲示板の一覧' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/boards'
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq('/login'), 'ログインページにリダイレクトされていません'
          expect(page).to have_content('ログインしてください'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        it 'ヘッダーのリンクから掲示板一覧へ遷移できること' do
          login_as(user)
          click_on('掲示板')
          click_on('掲示板一覧')
          Capybara.assert_current_path("/boards", ignore_query: true)
          expect(current_path).to eq('/boards'), 'ヘッダーのリンクから掲示板一覧画面へ遷移できません'
        end

        context '掲示板が一件もない場合' do
          it '何もない旨のメッセージが表示されること' do
            login_as(user)
            click_on('掲示板')
            click_on('掲示板一覧')
            expect(page).to have_content('掲示板がありません'), '掲示板が一件もない場合、「掲示板がありません」というメッセージが表示されていません'
          end
        end

        context '掲示板がある場合' do
          it '掲示板の一覧が表示されること' do
            board
            login_as(user)
            click_on('掲示板')
            click_on('掲示板一覧')
            expect(page).to have_content(board.title), '掲示板一覧画面に掲示板のタイトルが表示されていません'
            expect(page).to have_content(board.user.decorate.full_name), '掲示板一覧画面に投稿者のフルネームが表示されていません'
            expect(page).to have_content(board.body), '掲示板一覧画面に掲示板の本文が表示されていません'
          end
        end
      end
    end
    describe '掲示板の作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/boards/new'
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq('/login'), 'ログインしていない場合、掲示板作成画面にアクセスした際に、ログインページにリダイレクトされていません'
          expect(page).to have_content('ログインしてください'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        before do
          login_as(user)
          click_on('掲示板')
          click_on('掲示板作成')
        end

        it '掲示板が作成できること' do
          fill_in 'タイトル', with: 'テストタイトル'
          fill_in '本文', with: 'テスト本文'
          click_button '登録'
          Capybara.assert_current_path("/boards", ignore_query: true)
          expect(current_path).to eq('/boards'), '掲示板一覧画面に遷移していません'
          expect(page).to have_content('掲示板を作成しました'), 'フラッシュメッセージ「掲示板を作成しました」が表示されていません'
          expect(page).to have_content('テストタイトル'), '作成した掲示板のタイトルが表示されていません'
          expect(page).to have_content('テスト本文'), '作成した掲示板の本文が表示されていません'
        end

        it '掲示板の作成に失敗すること' do
          fill_in 'タイトル', with: 'テストタイトル'
          click_button '登録'
          expect(page).to have_content('掲示板を作成出来ませんでした'), 'フラッシュメッセージ「掲示板を作成出来ませんでした」が表示されていません'
          expect(page).to have_content('本文を入力してください'), 'エラーメッセージ「本文を入力してください」が表示されていません'
        end
      end
    end
  end
end
