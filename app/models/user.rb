class User < ApplicationRecord
  has_secure_password
  has_many :activity_ratings

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(e) { e.strip.downcase }
end
