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

  def display_date
    date_completed.strftime("%m/%d/%Y")
  end
end
