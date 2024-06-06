class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'chatroom_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    profile_id = current_user.profile.id
    profile = Profile.find_by(id: profile_id)
    post = Post.find(data['post_id'])
    group = post.group
    if group && profile
      chat = profile.chats.create!(body: data['message'], group: group)
      ActionCable.server.broadcast('chatroom_channel', {message: render_message(chat, profile)})
    end
  end

  def render_message(chat, profile)
    ApplicationController.render_with_signed_in_user(
      profile.user, 
      partial: 'chatrooms/chat', 
      locals: { chat: chat }
    )
  end  

end