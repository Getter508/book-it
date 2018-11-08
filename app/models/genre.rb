class Genre < ApplicationRecord
  GENRES = [
    "Action",
    "Adventure",
    "Autobiography",
    "Biography",
    "Children's books",
    "Classics",
    "Dystopias",
    "Fantasy",
    "Fiction",
    "Historical fiction",
    "History",
    "Horror",
    "Humor",
    "Medicine",
    "Murder",
    "Mystery",
    "Non-fiction",
    "Political fiction",
    "Psycological fiction",
    "Romance",
    "Satire",
    "Science",
    "Science fiction",
    "Suspense",
    "Thriller",
    "Travel",
    "Young adult fiction"
  ]

  GENRES_MAP = {
    "Adventure and adventurers" => "Adventure",
    "Adventure stories" => "Adventure",
    "American Science fiction" => "Science fiction",
    "BIOGRAPHY & AUTOBIOGRAPHY" => ["Biography", "Autobiography"],
    "Biography & Autobiography" => ["Biography", "Autobiography"],
    "Children's stories" => "Children's books",
    "Comedy" => "Humor",
    "Detective and mystery stories" => "Mystery",
    "Fantasy fiction" => ["Fantasy", "Fiction"],
    "Fiction in English" => "Fiction",
    "FICTION / Historical" => "Historical Fiction",
    "Horror stories" => "Horror",
    "Horror tales" => "Horror",
    "Juvenile fiction" => "Young adult fiction",
    "Love stories" => "Romance",
    "Mystery & Detective" => "Mystery",
    "Nonfiction" => "Non-fiction",
    "Science Fiction & Fantasy" => ["Science fiction", "Fantasy"],
    "Serial murders" => "Murder",
    "Suspense fiction" => "Suspense"
  }

  has_many :book_genres
  has_many :books, through: :book_genres

  validates_presence_of :name
  validates_uniqueness_of :name
end
