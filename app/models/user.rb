class User < ApplicationRecord
  NAME_MAX_LENGTH = 160
  EMAIL_MAX_LENGTH = 254
  PASSWORD_MIN_LENGTH = 12
  PASSWORD_MAX_LENGTH = 72
  EMAIL_FORMAT = /\A[^@\s]+@[^@\s]+\z/

  has_secure_password reset_token: false

  has_many :sessions, dependent: :destroy, inverse_of: :user

  enum :system_role,
    { user: "user", platform_admin: "platform_admin" },
    default: "user",
    validate: true

  normalizes :name, with: ->(value) { value.strip }
  normalizes :email, with: ->(value) { value.strip.downcase }

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :email,
    presence: true,
    length: { maximum: EMAIL_MAX_LENGTH },
    format: { with: EMAIL_FORMAT },
    uniqueness: { case_sensitive: false }
  validates :password,
    length: { minimum: PASSWORD_MIN_LENGTH, maximum: PASSWORD_MAX_LENGTH },
    allow_nil: true
  validates :active, inclusion: { in: [ true, false ] }
end
