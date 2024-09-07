require "sidekiq-scheduler"

class UpdateChatMessagesCountJob
  include Sidekiq::Worker

  def perform
    Chat.includes(:messages).find_each do |chat|
      chat.update(messages_count: chat.messages.count)
    end
    puts "updated messages counts for all chats"
  end
end
