class Message < ApplicationRecord
  # Association
  belongs_to :chat, dependent: :destroy

  # Validations
  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_id }

  # Callbacks
  before_validation :set_message_number, on: :create

  # Scopes
  scope :ordered, -> { order(id: :desc) }

  private
  def set_message_number
    last_message = chat.messages.order(number: :desc).first
    self.number = last_message ? last_message.number + 1 : 1
  end
end
