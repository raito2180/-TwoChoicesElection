class MembershipsController < ApplicationController
  def create
    group = Group.find(params[:group_id])
    membership = group.memberships.new(profile: current_user.profile, status: params[:status])

    if membership.save
      redirect_to request.referer, notice: '参加しました。'
    else
      redirect_to request.referer, alert: '参加に失敗しました。'
    end
  end
end
