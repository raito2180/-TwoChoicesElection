class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'chatroom_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast('chatroom_channel', {message: data['message']})
  end

end

def praspeak(data)
  group = Group.find_by(id: params[:group_id])
  profile = Profile.find_by(id: params[:profile_id])
  
  if group && profile
    chat = Chat.create!(body: data['message'], group: group, profile: profile)
    ActionCable.server.broadcast 'room_channel', message: chat.body
  end
end