class Application < ApplicationRecord
  # Association
  has_many :chats, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :token, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_token, on: :create
  after_commit :invalidate_all_applications_cache
  after_commit :invalidate_single_cache, on: [ :update, :destroy ]

  # Scopes
  scope :ordered, -> { order(id: :desc) }

  # Caching individual application by token
  def self.find_by_token!(token)
    Rails.cache.fetch("application_#{token}", expires_in: 1.hour) do
      find_by!(token: token)
    end
  end

  # Caching the list of applications
  def self.cached_all_applications
    Rails.cache.fetch("all_applications", expires_in: 1.hour) do
      ordered.to_a
    end
  end

  private
  def invalidate_all_applications_cache
    Rails.cache.delete("all_applications")
  end

  def invalidate_single_cache
    Rails.cache.delete("application_#{self.token}")
  end

  def generate_token
    self.token = SecureRandom.hex(16) until unique_token?
  end

  def unique_token?
    token.present? && !self.class.exists?(token: token)
  end
end
