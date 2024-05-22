class ProfilesController < ApplicationController
  

  def show; end

  def edit
  end

  def update
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :gender, :body, :image )
  end

end
