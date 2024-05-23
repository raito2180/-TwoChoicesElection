class ApplicationController < ActionController::Base
  before_action :set_profile
  before_action :ensure_profile

  private
  
  def redirect_root
    redirect_to root_path, flash: { success: 'ログインしてください' } unless user_signed_in?
  end

  def set_profile
    if user_signed_in?
      @profile = current_user.profile
    end
  end

  def ensure_profile
    if user_signed_in? && current_user.profile.nil?
      Profile.create(user: current_user, name: "ファン#{current_user.id}号", gender: 0, body: 'こんにちは、皆でフットサルやりましょう!')
    end
  end

end
