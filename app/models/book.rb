class YearValidator < ActiveModel::Validator
  def validate(record)
    if record.year.to_i > Time.zone.today.year
      record.errors[:base] << "Publication year cannot be in the future"
    end
  end
end

class Book < ApplicationRecord
  has_many :book_authors
  has_many :authors, through: :book_authors
  has_many :isbns

  validates_presence_of :title, :genre, :year
  validates :year, length: { is: 4 }, numericality: { only_integer: true }
  validates_with YearValidator

  mount_uploader :cover, ImageUploader
end
