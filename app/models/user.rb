class User < ApplicationRecord
  before_save :set_username, :set_email

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  has_secure_password

  validates :name, :username, presence: true
  validates :username, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :email,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 5, allow_blank: true }

  scope :regulars, -> { where("admin = ?", false) }
  scope :by_name, -> { regulars.order("name asc") }

  def gravatar_id
    Digest::MD5.hexdigest(email.downcase)
  end

  def to_param
    username
  end

  private

  def set_username
    self.username = username.parameterize
  end

  def set_email
    self.email = email.downcase
  end
end
