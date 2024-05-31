class MembershipsController < ApplicationController
  def create
    group = Group.find(params[:group_id])
    membership = group.memberships.new(profile: current_user.profile, status: params[:status])
    if membership.save
      redirect_to request.referer, notice: create_notice_message(membership.status)
    else
      redirect_to request.referer, alert: '状態の更新に失敗しました。'
    end
  end

  def update
    group = Group.find(params[:group_id])
    membership = group.memberships.find_by(profile: current_user.profile)

    if membership
      if membership.update(status: params[:status])
        redirect_to request.referer, notice: update_notice_message(membership.status)
      else
        redirect_to request.referer, alert: '状態の更新に失敗しました。'
      end
    else
      redirect_to request.referer, alert: 'Membershipが見つかりませんでした。'
    end
  end

  private

  def create_notice_message(status)
    case status
    when '参加'
      '参加しました。'
    when '不参加'
      '不参加で入力しました。'
    else
      '興味ありで入力しました。'
    end
  end

  def update_notice_message(status)
    case status
    when '参加'
      '参加に変更しました。'
    when '不参加'
      '不参加に変更しました。'
    else
      '興味ありに変更しました。'
    end
  end

end
