class UsersController < ApplicationController
  before_action :redirect_root
  def user_delete
    @user = current_user
    @user.destroy 
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end
end
