class MembershipsController < ApplicationController
  def create
    group = Group.find(params[:group_id])
    membership = group.memberships.new(profile: current_user.profile, status: params[:status])
    if membership.save
      redirect_to request.referer, notice: membership.decorate.create_notice_message
    else
      redirect_to request.referer, alert: '状態の更新に失敗しました。'
    end
  end

  def update
    group = Group.find(params[:group_id])
    membership = group.memberships.find_by(profile: current_user.profile)

    if membership
      if membership.update(status: params[:status])
        redirect_to request.referer, notice: membership.decorate.update_notice_message
      else
        redirect_to request.referer, alert: '状態の更新に失敗しました。'
      end
    else
      redirect_to request.referer, alert: 'Membershipが見つかりませんでした。'
    end
  end
end
