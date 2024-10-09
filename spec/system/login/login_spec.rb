require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
  let(:general_user) { create(:user, :general) }
  let(:admin_user) { create(:user, :admin) }

  describe '通常画面' do
    describe 'ログイン' do
      it '正しいタイトルが表示されていること' do
        visit '/login'
        expect(page).to have_title("ログイン | RUNTEQ BOARD APP"), '掲示板一覧ページのタイトルに「ログイン | RUNTEQ BOARD APP」が含まれていません。'
      end

      context '認証情報が正しい場合' do
        it 'ログインできること' do
          visit '/login'
          fill_in 'メールアドレス', with: general_user.email
          fill_in 'パスワード', with: '12345678'
          click_button 'ログイン'
          Capybara.assert_current_path("/boards", ignore_query: true)
          expect(current_path).to eq '/boards'
          expect(page).to have_content('ログインしました'), 'フラッシュメッセージ「ログインしました」が表示されていません'
        end
      end

      context 'PWに誤りがある場合' do
        it 'ログインできないこと' do
          visit '/login'
          fill_in 'メールアドレス', with: general_user.email
          fill_in 'パスワード', with: '1234'
          click_button 'ログイン'
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq('/login'), 'ログイン失敗時にログイン画面に戻ってきていません'
          expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
        end
      end
    end

    describe 'ログアウト' do
      before do
        login_as(general_user)
      end
      it 'ログアウトできること' do
        find('#header-profile').click
        click_on('ログアウト')
        Capybara.assert_current_path("/", ignore_query: true)
        expect(current_path).to eq root_path
        expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません'
      end
    end
  end
  describe '管理画面' do
    describe 'ログイン' do
      describe 'ログイン失敗' do
        context '管理者以外の場合' do
          it 'トップページにリダイレクトされること' do
            visit admin_login_path
            fill_in 'メールアドレス', with: general_user.email
            fill_in 'パスワード', with: '12345678'
            click_button 'ログイン'
            Capybara.assert_current_path("/", ignore_query: true)
            expect(current_path).to eq(root_path), '管理者権限がない場合に、ルートパスにリダイレクトされていません'
            expect(page).to have_content('権限がありません'), 'フラッシュメッセージ「権限がありません」が表示されていません'
          end
        end

        context '管理者の場合' do
          context 'PWに誤りがある場合' do
            it 'ログインできないこと' do
              visit admin_login_path
              fill_in 'メールアドレス', with: admin_user.email
              fill_in 'パスワード', with: '1234'
              click_button 'ログイン'
              Capybara.assert_current_path("/admin/login", ignore_query: true)
              expect(current_path).to eq(admin_login_path), '管理者用のログインページに遷移していません'
              expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
            end
          end

          context '認証情報が正しい場合' do
            it 'ログインできること' do
              visit admin_login_path
              fill_in 'メールアドレス', with: admin_user.email
              fill_in 'パスワード', with: '12345678'
              click_button 'ログイン'
              Capybara.assert_current_path("/admin", ignore_query: true)
              expect(current_path).to eq(admin_root_path), '管理者用のトップページに遷移していません'
              expect(page).to have_content('ログインしました'), 'フラッシュメッセージ「ログインしました」が表示されていません'
            end
          end
        end
      end
    end

    describe 'ログアウト' do
      before { login_as(admin_user) }
      it 'ログアウトできること' do
        visit admin_root_path
        click_on('ログアウト')
        Capybara.assert_current_path("/admin/login", ignore_query: true)
        expect(current_path).to eq(admin_login_path), '管理者用のログインページが表示されていません'
        expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません'
      end
    end
  end
end
