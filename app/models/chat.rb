class Chat < ApplicationRecord
  belongs_to :application
  validates :number, presence: true, uniqueness: { scope: :application_id }
  before_validation :set_chat_number, on: :create

  private
  def set_chat_number
    last_chat = application.chats.order(number: :desc).first
    self.number = last_chat ? last_chat.number + 1 : 1
  end
end
