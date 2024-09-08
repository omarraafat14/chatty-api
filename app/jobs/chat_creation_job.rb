
class ChatCreationJob
  include Sidekiq::Worker

  def perform(application_id, number, name)
    application = Application.find_by!(id: application_id)
    chat = Chat.new()
    chat.name = name
    chat.application = application
    chat.number = number
    chat.save
  end
end
