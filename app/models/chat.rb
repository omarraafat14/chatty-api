class Chat < ApplicationRecord
  # Association
  belongs_to :application
  has_many :messages, dependent: :destroy

  # Validations
  validates :number, presence: true, uniqueness: { scope: :application_id }

  # Callbacks
  before_validation :set_chat_number, on: :create

  # Scopes
  scope :ordered, -> { order(id: :desc) }

  private
  def set_chat_number
    last_chat = application.chats.order(number: :desc).first
    last_chat.with_lock do
      self.number = last_chat ? last_chat.number + 1 : 1
    end
  end
end
