require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#display_date' do
    it 'returns nil if have_read_book does not have a date completed' do
      have_read_book = create(:have_read_book, date_completed: nil)

      expect(have_read_book.display_date).to be_nil
    end

    it 'formats have_read_book date completed to mm/dd/yyyy' do
      have_read_book = create(:have_read_book)
      date = have_read_book.date_completed

      expect(have_read_book.display_date).to eq("#{date.strftime('%m/%d/%Y')}")
    end
  end

  describe '#build_date' do
    it 'converts date params into a datetime object if valid' do
      have_read_book = create(:have_read_book, date_completed: nil)
      params = ['Dec', '7', '2018']

      have_read_book.build_date(params)

      expect(have_read_book.date_completed).to eq("#{DateTime.parse('Dec 7, 2018')}")
    end

    it 'returns an error message if the datetime object is invalid' do
      have_read_book = create(:have_read_book, date_completed: nil)
      params = ['Feb', '31', '2018']

      expect(have_read_book.build_date(params)).to eq('invalid date')
      expect(have_read_book.date_completed).to be_nil
    end
  end

  describe '#has_empty_field?' do
    it 'returns true if date_completed, rating, or note are nil' do
      have_read_book = create(:have_read_book, date_completed: nil)

      expect(have_read_book.has_empty_field?).to be true
    end

    it 'returns false if date_completed, rating, or note are not nil' do
      have_read_book = create(:have_read_book)

      expect(have_read_book.has_empty_field?).to be false
    end
  end
end
