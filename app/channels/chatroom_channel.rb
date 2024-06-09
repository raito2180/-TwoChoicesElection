class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'chatroom_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    profile = Profile.find(data['profile_id'])
    post = Post.find(data['post_id'])
    group = post.group
    if group && profile
      chat = profile.chats.create!(body: data['message'], group: group)
      ActionCable.server.broadcast('chatroom_channel', {message: render_message(chat), chat_id: chat.id})
    end
  end

  def render_message(chat)
    ApplicationController.render_with_signed_in_user(
      chat.profile.user, 
      partial: 'chatrooms/mychat', 
      locals: { chat: chat }
    )
  end  

end