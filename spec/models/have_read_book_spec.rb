require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#display_date_completed' do
    it 'returns nil if have_read_book does not have a date completed' do
      have_read_book = create(:have_read_book, date_completed: nil)

      expect(have_read_book.display_date_completed).to be_nil
    end

    it 'formats have_read_book date completed to mm/dd/yyyy' do
      have_read_book = create(:have_read_book)
      date = have_read_book.date_completed

      expect(have_read_book.display_date_completed).to eq("#{date.strftime('%m/%d/%Y')}")
    end
  end

  describe '#display_date_created' do
    it 'formats have_read_book created_at date to mm/dd/yyyy' do
      have_read_book = create(:have_read_book)
      date = have_read_book.created_at

      expect(have_read_book.display_date_created).to eq("#{date.strftime('%m/%d/%Y')}")
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

  describe '#no_data?' do
    it 'returns true if there is no rating or note' do
      have_read_book = create(:have_read_book, note: nil, rating: nil)

      expect(have_read_book.no_data?).to be true
    end

    it 'returns false if rating or note are present' do
      have_read_book = create(:have_read_book, note: nil)

      expect(have_read_book.no_data?).to be false
    end
  end

  describe '.order_list' do
    it 'orders list with the current user on top and then newest to oldest' do
      have_read_book = create(:have_read_book, created_at: DateTime.current.prev_day)
      user = have_read_book.user
      book = have_read_book.book
      date = have_read_book.created_at
      have_read_book2 = create(:have_read_book, book: book, created_at: date.prev_day)
      have_read_book3 = create(:have_read_book, book: book)

      list = HaveReadBook.order_list(book_id: book.id, user: user)

      expect(list).to eq([have_read_book, have_read_book3, have_read_book2])
    end

    it 'returns empty if there are no have read books' do
      book = create(:book)
      user = create(:user)

      list = HaveReadBook.order_list(book_id: book.id, user: user)

      expect(list).to be_empty
    end
  end
end
