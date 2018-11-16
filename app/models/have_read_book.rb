# class CompletedDateValidator < ActiveModel::Validator
#   def validate(record)
#     if record.completed_date > Time.zone.current
#       record.errors[:base] << "Completed date cannot be in the future"
#     end
#   end
# end

class HaveReadBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates_presence_of :book_id, :user_id
  # validates_with CompletedDateValidator
end
