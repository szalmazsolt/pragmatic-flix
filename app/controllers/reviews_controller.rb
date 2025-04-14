class ReviewsController < ApplicationController
  before_action :set_movie, only: [ :index, :new, :create ]
  before_action :require_signin

  # GET /movies/:movie_id/reviews
  # GET /movies/:movie_id/reviews.json
  # GET /movies/:movie_id/reviews.xml

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_url(@movie), notice: "Thank you for your review!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :stars)
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end
