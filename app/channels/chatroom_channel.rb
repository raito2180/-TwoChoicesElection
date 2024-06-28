class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chatroom_channel'
  end

  def unsubscribed; end

  def speak(data)
    profile = Profile.find(data['profile_id'])
    post = Post.find(data['post_id'])
    group = post.group
    if group && profile
      chat = profile.chats.create!(body: data['message'], group:)
      ActionCable.server.broadcast('chatroom_channel', { message: render_message(chat), chat_id: chat.id, chat_profile_id: chat.profile.id })
    end
  end

  def render_message(chat)
    ApplicationController.render_with_signed_in_user(
      chat.profile.user,
      partial: 'chatrooms/mychat',
      locals: { chat: }
    )
  end
end
