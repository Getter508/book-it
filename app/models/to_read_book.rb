class InvalidSortParamError < StandardError; end
class InvalidDirectionParamError < StandardError; end

class ToReadBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates_presence_of :book_id, :user_id
  validates :book_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :rank, numericality: { only_integer: true }, allow_nil: true
end
