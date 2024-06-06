class ChatroomsController < ApplicationController
  before_action :redirect_root

  def show
    @post = Post.find_by(id: params[:post_id])
    @group = Group.find_by(id: params[:group_id])
    @chats = @group.chats
  end
end
