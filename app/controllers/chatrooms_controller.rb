class ChatroomsController < ApplicationController
  def show
    @chats = Chat.all
  end
end
