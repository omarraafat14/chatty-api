require "sidekiq-scheduler"

class UpdateApplicationChatCountJob
  include Sidekiq::Worker

  def perform
    Application.includes(:chats).find_each do |application|
      application.update(chats_count: application.chats.count)
    end
    puts "updated chat counts for all applications"
  end
end
