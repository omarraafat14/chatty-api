class Application < ApplicationRecord
  # Association
  has_many :chats, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :token, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_token, on: :create

  # Scopes
  scope :ordered, -> { order(id: :desc) }

  private

  def generate_token
    self.token = SecureRandom.hex(16) until unique_token?
  end

  def unique_token?
    token.present? && !self.class.exists?(token: token)
  end
end
