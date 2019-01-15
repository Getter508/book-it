# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |file|
#   require file
# end

require_relative 'seeds/books_seed'
require_relative 'seeds/authors_seed'
require_relative 'seeds/book_authors_seed'
require_relative 'seeds/genres_seed'
require_relative 'seeds/book_genres_seed'
require_relative 'seeds/isbns_seed'
require_relative 'seeds/users_seed'
require_relative 'seeds/to_read_books_seed'
require_relative 'seeds/have_read_books_seed'
