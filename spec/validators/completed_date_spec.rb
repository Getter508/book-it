require 'rails_helper'

RSpec.describe CompletedDateValidator, type: :validator do
  describe 'completed date validator' do
    it 'should raise an error if completed date is invalid' do
      book = create(:book)
      user = create(:user)
      year = Time.zone.now.year + 2
      date_completed = DateTime.parse("Dec 7, #{year}")
      have_read_book = HaveReadBook.new(book_id: book.id, user_id: user.id, date_completed: date_completed)

      expect(have_read_book).not_to be_valid
      expect(have_read_book.errors.full_messages).to include('Completed date cannot be in the future')
    end

    it 'should allow the object to be created if valid' do
      book = create(:book)
      user = create(:user)
      have_read_book = HaveReadBook.new(book_id: book.id, user_id: user.id)

      expect(have_read_book).to be_valid
      expect(have_read_book.errors.full_messages).to be_empty
    end
  end
end
