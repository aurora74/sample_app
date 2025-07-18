class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MAX_NAME_LENGTH = 50
  MAX_EMAIL_LENGTH = 255
  MAX_AGE_YEARS = 100
  MIN_PASSWORD_LENGTH = 6

  before_save{self.email = email.downcase}

  validates :name, presence: true, length: {maximum: MAX_NAME_LENGTH}
  validates :email, presence: true, length: {maximum: MAX_EMAIL_LENGTH},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :birthday, presence: true,
    inclusion: {in: MAX_AGE_YEARS.years.ago.to_date..Date.current}
  validates :password, length: {minimum: MIN_PASSWORD_LENGTH}, allow_nil: true
end
