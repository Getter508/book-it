class Isbn < ApplicationRecord
  belongs_to :book

  validates_presence_of :book_id, :isbn
  validates_uniqueness_of :isbn
end
