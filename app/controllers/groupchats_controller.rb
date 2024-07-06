class GroupchatsController < ApplicationController
  def index
    profile = current_user.profile
    memberships = profile.memberships.where(status: "参加")
    group_ids = memberships.pluck(:group_id)
    @groupchats = Post.joins(:group).where(groups: { id: group_ids })
  end
end
