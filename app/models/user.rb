class User < ApplicationRecord
  USER_PARAMS = [:name, :address, :phone, :email, :password,
    :password_confirmation, :current_password].freeze

  devise :database_authenticatable, :registerable, :validatable, :confirmable,
    :recoverable

  attr_accessor :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save{email.downcase!}

  has_many :comments, dependent: :destroy
  has_many :rattings, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.maximum.name}
  validates :address, presence: true,
    length: {maximum: Settings.maximum.address}
  validates :phone, presence: true, length: {maximum: Settings.maximum.phone}
  validates :email, presence: true, length: {maximum: Settings.maximum.email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.minimum.pass},
    allow_nil: true

  enum role: {member: 0, admin: 1}

  scope :newest, ->{order created_at: :DESC}
  scope :search, ->(key) do
    where "name LIKE ? OR email LIKE ?", "%#{key}%", "%#{key}%"
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Password.create string, cost: BCrypt::Engine::MIN_COST
      else
        BCrypt::Password.create string, cost: BCrypt::Engine.cost
      end
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
