class InvalidSortParamError < StandardError; end
class InvalidDirectionParamError < StandardError; end

class ToReadBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates_presence_of :book_id, :user_id
  validates :book_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :rank, numericality: { only_integer: true }, allow_nil: true

  AUTHOR = 'author'
  SORTING_ATTRIBUTES = ['title', AUTHOR]

  def self.order_by(params)
    raise InvalidSortParamError unless SORTING_ATTRIBUTES.include?(params[:sort])
    raise InvalidDirectionParamError unless ['asc', 'desc'].include?(params[:direction])
    query = "#{query_for(params[:sort])} #{params[:direction]}"
    if params[:sort] == AUTHOR
      self.joins(:authors).order(query)
    else
      self.order(query)
    end
  end

  private

  def self.query_for(sort)
    sort == AUTHOR ? "authors.name" : sort
  end
end
