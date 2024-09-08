class Message < ApplicationRecord
  # Association
  belongs_to :chat, dependent: :destroy

  # Validations
  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_id }

  # Callbacks
  before_validation :set_message_number, on: :create
  after_commit :invalidate_chat_messages_cache
  after_commit :invalidate_single_message, on: [:destroy, :update]

  # Scopes
  scope :ordered, -> { order(id: :desc) }

  # Caching individual message by number
  def self.find_by_number!(number)
    Rails.cache.fetch("message_#{number}", expires_in: 1.hour) do
      find_by!(number: number)
    end
  end

  def invalidate_chat_messages_cache
    Rails.cache.delete("chat_#{self.chat.number}_messages")
  end

  def invalidate_single_message
    Rails.cache.delete("message_#{self.number}")
  end

  private
  def set_message_number
    last_message = chat.messages.order(number: :desc).first
    last_message.with_lock do
      self.number = last_message ? last_message.number + 1 : 1
    end
  end
end
