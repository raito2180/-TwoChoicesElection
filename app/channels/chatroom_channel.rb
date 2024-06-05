class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'chatroom_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    group = Group.find_by(params[:group])
    profile = Profile.find_by(params[:profile])
    if group && profile
      chat = Chat.create!(body: data['message'], group: group, profile: profile)
      ActionCable.server.broadcast('chatroom_channel', {message: render_message(chat,profile)})
    end
  end

  def render_message(chat, profile)
    ApplicationController.render_with_signed_in_user(
      profile.user, 
      partial: 'chatrooms/chat', 
      locals: { chat: chat, profile: profile }
    )
  end  

end