class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  rescue => err
    puts "Error: #{err.message}"
    redirect_to movies_url
  end
end
