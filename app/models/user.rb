class User < ApplicationRecord
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  USER_PERMIT = %i(name email password password_confirmation birthday
gender).freeze
  PASSWORD_RESET_PERMIT = %i(password password_confirmation).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MAX_NAME_LENGTH = 50
  MAX_EMAIL_LENGTH = 255
  MAX_AGE_YEARS = 100
  MIN_PASSWORD_LENGTH = 6

  enum gender: {female: 0, male: 1, other: 2}

  scope :latest_first, -> {order(created_at: :desc)}

  before_save{self.email = email.downcase}
  before_create :create_activation_digest

  attr_accessor :remember_token, :session_token, :activation_token, :reset_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    # When remembering, overwrite session_token with
    # remember_token in remember_digest
    update_column(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_column(:remember_digest, nil)
    self.remember_token = nil
  end

  def generate_session_token
    self.session_token = User.new_token
    # When logging in, update remember_digest with session_token to validate
    update_column(:remember_digest, User.digest(session_token))
  end

  def forget_session
    # Clear remember_digest khi logout
    update_column(:remember_digest, nil)
    self.session_token = nil
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Creates and assigns the reset token and digest
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Sends password reset confirmation email
  def send_password_reset_confirmation_email
    UserMailer.password_reset_confirmation(self).deliver_now
  end

  # Returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < Settings.password_reset.expires_in.hours.ago
  end

  # Follows a user
  def follow user
    following << user unless self == user
  end

  # Unfollows a user
  def unfollow user
    following.delete(user)
  end

  # Returns true if the current user is following the other user
  def following? user
    following.include?(user)
  end

  # Returns the user's feed microposts
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                    user_id: id).includes(:user, image_attachment: :blob).newest
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  validates :name, presence: true,
                   length: {maximum: MAX_NAME_LENGTH}
  validates :email, presence: true,
                    length: {maximum: MAX_EMAIL_LENGTH},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :birthday, presence: true,
                       inclusion:
                       {in: MAX_AGE_YEARS.years.ago.to_date..Date.current}
  validates :gender, presence: true
  validates :password,
            length: {minimum: MIN_PASSWORD_LENGTH}, allow_nil: true
end
