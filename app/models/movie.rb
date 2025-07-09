class Movie < ApplicationRecord
  before_save :set_slug

  has_many :reviews, -> { order("created_at desc") }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_one_attached :main_image

  validates :title, :released_on, :duration, presence: true
  validates :title, uniqueness: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  RATINGS = %w[G PG PG-13 R NC-17]
  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where("released_on < ?", Time.now).order("released_on desc") }
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :hits, -> { released.where("total_gross > ?", 225_000_000).order("total_gross desc") }
  scope :flops, -> { released.where("total_gross < ?", 225_000_000).order("total_gross desc") }
  scope :grossed_less_than, ->(grossed) { released.where("total_gross < ?", grossed) }
  scope :grossed_greater_than, ->(grossed) { released.where("total_gross > ?", grossed) }

  # def self.hits
  #   where(total_gross: 225_000_000..).order(total_gross: :desc)
  # end

  # def self.flops
  #   where(total_gross: ..225_000_000).order(:total_gross)
  # end

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

  def to_param
    slug
  end

  private

  def set_slug
    # we need to use self here, otherwise slug will be treated as a local variable, not an attribute of a movie object
    self.slug = title.parameterize
  end
end
