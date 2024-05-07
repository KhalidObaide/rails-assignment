# Movies ( take-home assignment )

* to setup & run the **import-task**
```bash
bin/rails db:migrate
bin/rails import:csv
```
_Note_: Place the files inside the `data` directory under the names `movies.csv` and `reviews.csv`


### Defined goals:
This assignment is about writing a small Ruby On Rails application. Use a methodology that works for you or that you are used to.

1. Create a new application with Ruby on Rails
2. Study the content of movies.csv and reviews.csv
3. Define a database schema and add it to your application
4. Write an import task to import both CSV-files
5. Show an overview of all movies in your application
6. Make a search form to search for an actor
7. Sort the overview by average stars (rating) in an efficient way
**Design CSV importer/application for heavy data processing 


### Solution:
**Step1:** After creating a new rails app I started to study the two files and this was my conclusion:
* `movies.csv` file includes duplicated movie records but with different actors in each row. This means I have to create two tables (`movies` and `actors`) and link them together with a many to many relationship.
* `reviews.csv` is straightforward, a list of review records with the movie title ( we can use movie title to match it with the movies table)

**Step2** Creating an import task that performs well for heavy data processing.
* Using the rails template I was able to put together the task template to read the csv and import into the database.
* To improve the performance for larger datasets, I implemented the batching mechanism with a batch-size of 1000.
* Separating the tables into 3 ( `movies`, `actors` and `reviews` ) also helped avoiding multiple insertion of the same records which hugely improves the performance when working with larger datasets.   

**Step3** Create an overview form & Search by actors.
* Used a controller to properly fetch the movie record with the required joins.
* I joined all the actors for each movie, so that it returns a column with actors_names listed 
* I joined it with the reviews table and a basic math to calculate reviews_count and rating ( based on average of stars )
* To perform on larger datasets I decided to do a database-side filtering ( in our case a string search ). where we search if a specific sequence of characters exist in any of the movies' actors' names.


### Final Word:
This was an amazing challenge to test ruby-on-rails skills, however I think if the requirements were more clear, it would have helped a lot.\
For example: I didn't know if the data-duplication is an error or is intended.
