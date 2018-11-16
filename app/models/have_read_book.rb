class CompletedDateValidator < ActiveModel::Validator
  def validate(record)
    if record.date_completed > Time.zone.now
      record.errors[:base] << "Completed date cannot be in the future"
    end
  end
end

class InvalidSortParamError < StandardError; end
class InvalidDirectionParamError < StandardError; end

class HaveReadBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates_presence_of :book_id, :user_id
  validates_with CompletedDateValidator

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
