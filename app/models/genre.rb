class Genre < ApplicationRecord
  GENRES = [
    'Action',
    'Adventure',
    'Autobiography',
    'Biography',
    "Children's books",
    'Classics',
    'Dystopias',
    'Fantasy',
    'Fiction',
    'Historical fiction',
    'History',
    'Horror',
    'Humor',
    'Medicine',
    'Murder',
    'Mystery',
    'Non-fiction',
    'Political fiction',
    'Psycological fiction',
    'Romance',
    'Satire',
    'Science',
    'Science fiction',
    'Suspense',
    'Thriller',
    'Travel',
    'Young adult fiction'
  ]

  GENRES_MAP = {
    'Adventure and adventurers' => 'Adventure',
    'Adventure stories' => 'Adventure',
    'American science fiction' => 'Science fiction',
    'Biography & autobiography' => ['Biography', 'Autobiography'],
    "Children's stories" => "Children's books",
    'Comedy' => 'Humor',
    'Detective and mystery stories' => 'Mystery',
    'Fantasy fiction' => ['Fantasy', 'Fiction'],
    'Fiction in english' => 'Fiction',
    'Fiction / historical' => 'Historical fiction',
    'Horror stories' => 'Horror',
    'Horror tales' => 'Horror',
    'Juvenile fiction' => 'Young adult fiction',
    'Love stories' => 'Romance',
    'Mystery & detective' => 'Mystery',
    'Nonfiction' => 'Non-fiction',
    'Science fiction & fantasy' => ['Science fiction', 'Fantasy'],
    'Serial murders' => 'Murder',
    'Suspense fiction' => ['Suspense', 'Fiction']
  }

  PROMPT = '-- Select a Genre --'

  has_many :book_genres
  has_many :books, through: :book_genres

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.select_options
    Genre.all.order(:name).map { |genre| [genre.name, genre.id] }
  end
end
