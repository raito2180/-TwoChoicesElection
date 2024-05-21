class ProfilesController < ApplicationController
  

  def show
    @profile = current_user.profile
  end

  def edit
  end

  def update
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :gender, :body, :images )
  end

end
