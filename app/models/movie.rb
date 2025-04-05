class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name,
            format: {
              with: /\w+\.(jpg|png)\z/i,
              message: "must be a JPG or PNG image"
            }
  RATINGS = %w[G PG PG-13 R NC-17]
  validates :rating, inclusion: { in: RATINGS }

  def self.released
    where("released_on < ?", Time.now).order("released_on desc")
  end

  def self.hits
    where(total_gross: 225_000_000..).order(total_gross: :desc)
  end

  def self.flops
    where(total_gross: ..225_000_000).order(:total_gross)
  end

  def self.recently_added
    order(created_at: :desc).limit(3)
  end


  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end

  def cult?
    reviews.size > 50 && average_stars >= 4.5
  end

  def average_stars
    if reviews.size.zero?
      0.0
    else
      # Calculate the average of the stars from the reviews
      # and round it to 2 decimal places
      # This assumes that the reviews table has a column named 'stars'
      # and that it contains integer values between 1 and 5
      # The average is calculated using ActiveRecord's average method
      # and rounded to 2 decimal places
      reviews.average(:stars).round(2)
    end
  end

  def average_stars_as_percent
    average_stars * 100 / 5
  end
end
