class ProfilesController < ApplicationController
  

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: 'プロフィールを更新しました'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :gender, :body, :image )
  end

end
