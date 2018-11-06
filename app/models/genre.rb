class Genre < ApplicationRecord
  GENRES = [
    "Action",
    "Adventure",
    "Autobiography",
    "Biography",
    "Children's books",
    "Fantasy",
    "Fiction",
    "Historical fiction",
    "History",
    "Humor",
    "Murder",
    "Mystery",
    "Non-Fiction",
    "Science fiction",
    "Suspense",
    "Thriller"
  ]

  GENRES_MAP = {"American Science fiction" => "Science fiction"}

  has_many :book_genres
  has_many :books, through: :book_genres

  validates_presence_of :name
  validates_uniqueness_of :name
end
