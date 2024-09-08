class Chat < ApplicationRecord
  # Association
  belongs_to :application
  has_many :messages, dependent: :destroy

  # Validations
  validates :number, presence: true, uniqueness: { scope: :application_id }
  validates :name, presence: true

  # Callbacks
  before_validation :set_chat_number, on: :create
  after_commit :invalidate_application_chats_cache
  after_commit :invalidate_single_chat, on: [:destroy, :update]

  # Scopes
  scope :ordered, -> { order(id: :desc) }

  def invalidate_application_chats_cache
    Rails.cache.delete("application_#{self.application.token}_chats")
  end

  def invalidate_single_chat
    Rails.cache.delete("chat_#{self.number}")
  end
  
  # Caching individual chat by number
  def self.find_by_number!(number)
    puts "find_by_number!"
    Rails.cache.fetch("chat_#{number}", expires_in: 1.hour) do
      find_by!(number: number)
    end
  end

  # Caching messages related to this chat
  def cached_messages
    Rails.cache.fetch("chat_#{number}_messages", expires_in: 1.hour) do
      messages.ordered.to_a
    end
  end

  private
  def set_chat_number
    last_chat = application.chats.order(number: :desc).first
    return self.number = 1 unless last_chat
    last_chat.with_lock do
      self.number = last_chat.number + 1
    end
  end
end
