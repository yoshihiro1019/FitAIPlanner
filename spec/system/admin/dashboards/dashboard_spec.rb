require 'rails_helper'

RSpec.describe '管理画面/ダッシュボード', type: :system do
  let(:general_user) { create(:user, :general) }
  let(:admin_user) { create(:user, :admin) }
  describe 'アドミン系画面' do
    context 'ログイン前画面' do
      describe 'ログインページ' do
        it '正しいタイトルが表示されていること' do
          visit admin_login_path
          expect(page).to have_title('管理画面'), '管理画面のログインページのタイトルに「管理画面」が含まれていません'
          expect(page).to have_title('ログイン'), '管理画面のログインページのタイトルに「ログイン」が含まれていません'
        end
      end
    end

    describe 'ログイン後画面' do
      before { login_as(admin_user) }
      describe 'ダッシュボード' do
        it '正しいタイトルが表示されていること' do
          visit admin_root_path
          expect(page).to have_title('管理画面'), '管理画面のダッシュボードのタイトルに「管理画面」が含まれていません'
          expect(page).to have_title('ダッシュボード'), '管理画面のダッシュボードのタイトルに「ダッシュボード」が含まれていません'
        end
      end
    end
  end

  describe '権限によるアクセス制御' do
    context '一般ユーザーの場合' do
      it 'アクセスできないこと' do
        login_as(general_user)
        visit admin_root_path
        Capybara.assert_current_path("/", ignore_query: true)
        expect(current_path).to eq(root_path), '管理者権限のない一般ユーザーは、トップページに遷移させてください'
        expect(page).to have_content '権限がありません'
      end
    end

    context '管理者の場合' do
      it 'アクセスできること' do
        login_as(admin_user)
        visit admin_root_path
        Capybara.assert_current_path("/admin", ignore_query: true)
        expect(current_path).to eq(admin_root_path), '管理者用のトップページに遷移させてください'
        expect(page).to have_content 'ダッシュボードです'
      end
    end
  end
end