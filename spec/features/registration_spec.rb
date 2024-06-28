require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  before do
    visit root_path
    find('.dropdown').click
    click_on('ユーザー登録')
  end

  context "when ユーザー登録が正常に完了する場合" do
    scenario 'ユーザー登録が正常に完了すること' do
      fill_in 'user_email', with: 'test@yahoo.com'
      fill_in 'user_password', with: '111111'
      fill_in 'user_password_confirmation', with: '111111'
      click_button '登録'
      expect(page).to have_content('ようこそ！ユーザー登録が完了しました。')
    end
  end

  context "when バリデーションエラーが発生する場合" do
    scenario 'メールアドレスが空の場合、エラーメッセージが表示されること' do
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: '111111'
      fill_in 'user_password_confirmation', with: '111111'
      click_button '登録'
      expect(page).to have_content("Eメールを入力してください")
    end

    scenario 'パスワードが空の場合、エラーメッセージが表示されること' do
      fill_in 'user_email', with: 'test@yahoo.com'
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: '111111'
      click_button '登録'
      expect(page).to have_content("パスワードを入力してください")
    end

    scenario '確認パスワードが空の場合、エラーメッセージが表示されること' do
      fill_in 'user_email', with: 'test@yahoo.com'
      fill_in 'user_password', with: '111111'
      fill_in 'user_password_confirmation', with: ''
      click_button '登録'
      expect(page).to have_content("パスワード（確認用）とパスワードの入力が一致しません")
    end
  end
end
