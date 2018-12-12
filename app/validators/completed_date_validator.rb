class CompletedDateValidator < ActiveModel::Validator
  def validate(record)
    unless record.date_completed.nil?
      if record.date_completed > Time.zone.now
        record.errors[:base] << 'Completed date cannot be in the future'
      end
    end
  end
end
