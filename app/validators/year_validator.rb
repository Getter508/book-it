class YearValidator < ActiveModel::Validator
  def validate(record)
    if record.year.to_i > Time.zone.today.year
      record.errors[:base] << 'Publication year cannot be in the future'
    end
  end
end
