class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  validates :comment, length: { minimum: 4 }

  STARS = [ 1, 2, 3, 4, 5 ]
  validates :stars, inclusion: { in: STARS, message: "must be between 1 and 5" }

  scope :past_n_days, ->(n) { where("created_at >= ?", n.days_ago) }

  def stars_as_percent = stars * 100 / 5
end
