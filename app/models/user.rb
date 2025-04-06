class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  validates :password, length: { min: 5, allow_blank: true }
end
