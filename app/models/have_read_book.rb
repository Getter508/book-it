class InvalidSortParamError < StandardError; end
class InvalidDirectionParamError < StandardError; end

class HaveReadBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates_presence_of :book_id, :user_id
  validates :rating, numericality: { only_integer: true, greater_than: 0,
    less_than_or_equal_to: 10 }, allow_nil: true
  validates :note, length: { maximum: 1000 }
  validates_with CompletedDateValidator

  paginates_per 30

  MONTHS = (1..12).map { |m| I18n.l(DateTime.parse(Date::MONTHNAMES[m]), format: '%b') }
  DAYS = (1..31).to_a
  YEARS = ((Time.zone.now.year - 9)..Time.zone.now.year).to_a
  RATINGS = (1..10).to_a

  def display_date
    date_completed&.strftime('%m/%d/%Y')
  end

  def build_date(params)
    self.date_completed = DateTime.parse("#{params.first} #{params[1]}, #{params.last}")
  rescue ArgumentError => e
    return e.message
  end

  def has_empty_field?
    date_completed.nil? || rating.nil? || note.nil?
  end

  def self.default_sort
    "#{table_name}.rating desc, date_completed desc"
  end
end
