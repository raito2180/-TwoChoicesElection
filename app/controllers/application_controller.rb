class ApplicationController < ActionController::Base

  private
  
  def redirect_root
    redirect_to root_path, flash: { success: 'ログインしてください' } unless user_signed_in?
  end

end
