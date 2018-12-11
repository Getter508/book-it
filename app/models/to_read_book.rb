class InvalidSortParamError < StandardError; end
class InvalidDirectionParamError < StandardError; end

class ToReadBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates_presence_of :book_id, :user_id
  validates :book_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :rank, numericality: { only_integer: true, greater_than: 0,
    less_than_or_equal_to: 10 }, allow_nil: true

  MAX_RANK = 10
  RANKS = (1..MAX_RANK).to_a

  def decrement_rank!
    update(rank: rank - 1)
  end

  def increment_rank!
    update(rank: rank_plus_one)
  end

  def rank_plus_one
    rank < MAX_RANK ? rank + 1: nil
  end

  def self.default_sort
    "#{table_name}.rank asc"
  end

  def self.find_and_destroy(user:, book_id:)
    to_read_book = self.find_by(user: user, book_id: book_id)
    user.update_ranks(book_id: book_id, old_rank: to_read_book&.rank, new_rank: nil)
    to_read_book&.destroy
  end
end
