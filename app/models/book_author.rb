class BookAuthor < ApplicationRecord
  belongs_to :book
  belongs_to :author

  validates_presence_of :book_id, :author_id
end
