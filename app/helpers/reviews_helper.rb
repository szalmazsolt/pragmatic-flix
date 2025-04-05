module ReviewsHelper
  def average_stars(movie, options = { show_asterisk: false })
    if movie.average_stars.zero?
      content_tag(:strong, "No reviews yet")
    else
      "Average rating: " + (options[:show_asterisk] ? "*" * movie.average_stars.round : pluralize(number_with_precision(movie.average_stars, precision: 1), "star")) + " out of 5"
    end
  end
end
