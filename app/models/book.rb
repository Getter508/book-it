class YearValidator < ActiveModel::Validator
  def validate(record)
    if record.year.to_i > Time.zone.today.year
      record.errors[:base] << "Publication year cannot be in the future"
    end
  end
end

class InvalidSortParamError < StandardError; end
class InvalidDirectionParamError < StandardError; end

class Book < ApplicationRecord
  has_many :book_authors
  has_many :authors, through: :book_authors
  has_many :isbns
  has_many :book_genres
  has_many :genres, through: :book_genres
  has_many :have_read_books

  validates_presence_of :title, :year
  validates :year, length: { is: 4 }, numericality: { only_integer: true }
  validates_with YearValidator

  paginates_per 30

  def display_cover
    cover.nil? ? "generic_book_cover1.png" : cover
  end

  def self.filter(filter)
    self.joins(:genres).where(genres: { id: filter }) if filter
  end

  SORTING_ATTRIBUTES = ['title', 'author']

  def self.order_by(params)
    raise InvalidSortParamError unless SORTING_ATTRIBUTES.include?(params[:sort])
    raise InvalidDirectionParamError unless ['asc', 'desc'].include?(params[:direction])
    query = "#{query_for(params[:sort])} #{params[:direction]}"
    if params[:sort] == 'author'
      self.joins(:authors).order(query)
    else
      self.order(query)
    end
  end

  private

  def self.query_for(sort)
    sort == 'author' ? "authors.name" : sort
  end
end


# def self.sortable_title
#   title.sub(/^(the|a|an)\s+/i, '')
# end
