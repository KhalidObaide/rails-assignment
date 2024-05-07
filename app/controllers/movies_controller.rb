class MoviesController < ApplicationController
  def index
    @movies = Movie.left_joins(:reviews, :actors)
                   .select('movies.*, 
                           COUNT(DISTINCT reviews.id) AS reviews_count, 
                           AVG(reviews.stars) AS average_rating, 
                           GROUP_CONCAT(DISTINCT actors.name) AS actor_names')
                   .group('movies.id')
                   .order(Arel.sql('average_rating DESC NULLS LAST'))

    if params[:actor].present?
      @movies = @movies.where('movies.id IN (
                                  SELECT DISTINCT movies.id
                                  FROM movies
                                  INNER JOIN actors_movies ON movies.id = actors_movies.movie_id
                                  INNER JOIN actors ON actors_movies.actor_id = actors.id
                                  WHERE actors.name LIKE ?
                              )', "%#{params[:actor]}%")
    end
  end
end
