class ChatBroadcastJob < ApplicationJob
  queue_as :default

  def perform(*args)
  end
end
