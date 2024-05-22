class ApplicationController < ActionController::Base
  before_action :set_profile

  private
  
  def redirect_root
    redirect_to root_path, flash: { success: 'ログインしてください' } unless user_signed_in?
  end

  def set_profile
    if user_signed_in?
      @profile = current_user.profile
    end
  end

end
