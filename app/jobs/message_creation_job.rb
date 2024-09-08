
class MessageCreationJob
  include Sidekiq::Worker

  def perform(chat_id, number, body)
    chat = Chat.find_by!(id: chat_id)
    message = Message.new()
    message.body = body
    message.chat = chat
    message.number = number
    message.save
  end
end
