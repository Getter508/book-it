class YearValidator < ActiveModel::Validator
  def validate(record)
    if record.year.to_i > Time.zone.today.year
      record.errors[:base] << 'Publication year cannot be in the future'
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
  has_many :to_read_books

  validates_presence_of :title, :year
  validates :year, length: { is: 4 }, numericality: { only_integer: true }
  validates_with YearValidator

  paginates_per 30

  DEFAULT_COVER = 'generic_book_cover1.png'.freeze
  SORTING_ATTRIBUTES = ['title', 'author', nil].freeze

  def display_cover
    cover.nil? ? DEFAULT_COVER : cover
  end

  def brief_description
    if description.nil? || description.length <= 220
      description
    else
      description.slice(0..220) + '...'
    end
  end

  def display_genres
    genres.pluck(:name).join(', ')
  end

  def display_authors
    if authors.size == 2
      authors.pluck(:name).join(' & ')
    else
      authors.pluck(:name).join(', ')
    end
  end

  def self.filter(genre_id: nil)
    self.joins(:genres).where(genres: { id: genre_id })
  end

  def self.order_by(params, model)
    raise InvalidSortParamError unless SORTING_ATTRIBUTES.include?(params[:sort])
    raise InvalidDirectionParamError unless ['asc', 'desc', nil].include?(params[:direction])
    query = "#{query_for(params[:sort])} #{params[:direction]}"
    if params[:sort].nil?
      self.order(model.default_sort)
    elsif params[:sort] == 'author'
      self.joins(:authors).order(query)
    else
      self.order(query)
    end
  end

  def self.default_sort
    Arel.sql('random()')
  end

  private

  def self.query_for(sort)
    sort == 'author' ? 'authors.name' : sort
  end
end
