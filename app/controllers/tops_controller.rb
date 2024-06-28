class TopsController < ApplicationController
  def index
    @profile = current_user.profile if user_signed_in?
  end
end
