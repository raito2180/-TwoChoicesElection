class TopsController < ApplicationController
  def index
    @profile = current_user.profile
  end
end
