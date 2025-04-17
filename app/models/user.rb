class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  has_secure_password

  validates :name, presence: true
  validates :username, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :email,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 5, allow_blank: true }

  def gravatar_id
    Digest::MD5.hexdigest(email.downcase)
  end
end
