class Isbn < ApplicationRecord
  LENGTHS = [10, 13]

  belongs_to :book

  validates_presence_of :book_id, :international_standard_book_number
  validates_uniqueness_of :international_standard_book_number

  def value
    international_standard_book_number
  end
end
