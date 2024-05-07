namespace :import do
  desc "Import data from CSV files"
  task :csv => :environment do
    require 'csv'

    puts "Starting data import..."

    # Import movies
    puts "Importing movies..."
    import_movies('data/movies.csv')

    # Import reviews
    puts "Importing reviews..."
    import_reviews('data/reviews.csv')

    puts "Data import completed successfully."
  end

  def import_movies(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      movie = Movie.find_or_create_by(title: row['Movie']) do |m|
        m.description = row['Description']
        m.year = row['Year']
        m.director = row['Director']
        m.filming_location = row['Filming location']
        m.country = row['Country']
      end

      actors = row['Actor'].split(',').map(&:strip)
      actors.each do |actor_name|
        actor = Actor.find_or_create_by(name: actor_name)
        movie.actors << actor unless movie.actors.include?(actor)
      end
    end
  end

  def import_reviews(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      movie = Movie.find_by(title: row['Movie'])
      next unless movie # Skip if movie not found
      Review.create!(
        movie: movie,
        user: row['User'],
        stars: row['Stars'],
        review: row['Review']
      )
    end
  end
end
