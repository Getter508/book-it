class BookGenre < ApplicationRecord
  belongs_to :book
  belongs_to :genre

  validates_presence_of :book_id, :genre_id 
end
