require 'rails_helper'

RSpec.describe YearValidator, type: :validator do
  describe 'year validator' do
    it 'should raise an error if year is invalid' do
      year = Time.zone.now.year + 2
      book = Book.new(title: 'Title', year: year)

      expect(book).not_to be_valid
      expect(book.errors.full_messages).to include('Publication year cannot be in the future')
    end

    it 'should allow the object to be created if valid' do
      year = Time.zone.now.year - 1
      book = Book.new(title: 'Title', year: year)

      expect(book).to be_valid
      expect(book.errors.full_messages).to be_empty
    end
  end
end
