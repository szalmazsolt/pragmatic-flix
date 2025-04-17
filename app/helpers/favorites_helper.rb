module FavoritesHelper
  def fav_or_unfav_button(favorite, movie)
    if favorite
        button_to "♡ Unfave", movie_favorite_path(movie, favorite), method: :delete
    else
      button_to "♥️ Fave", movie_favorites_path(movie)
    end
  end
end
