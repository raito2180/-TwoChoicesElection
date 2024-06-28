require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録(モデル)' do
    it "メールアドレス、パスワード、確認パスワードが存在すれば登録できること" do
      user = build(:user)
      expect(user).to be_valid
    end

    context "when バリデーションエラーが発生する場合" do
      it "メールアドレスが存在しない場合登録できないこと" do
        user = build(:user, email: '')
        expect(user).to be_invalid
      end

      it "パスワードが存在しない場合登録できないこと" do
        user = build(:user, password: '')
        expect(user).to be_invalid
      end

      it "確認パスワードが存在しない場合登録できないこと" do
        user = build(:user, password_confirmation: '')
        expect(user).to be_invalid
      end
    end
  end
end
