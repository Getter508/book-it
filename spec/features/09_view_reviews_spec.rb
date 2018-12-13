require 'rails_helper'

feature 'user views reviews for a book' do
  before(:each) do
    sign_in user
  end

  # As a user
  # I can view the reviews for a book
  # So that I can see how people feel about it
  #
  # Acceptance Criteria:
  #   All reviews for a book appear on the book's details page
  #   My review appears at the top if I have reviewed the book
  #   The rest of the reviews are ordered newest to oldest
  #   If there are no reviews, 'None' appears in the reviews section
  #   My rating appears on my 'Have Read' list and next to the book info on the
  #     browse and search pages
  scenario 'there are no reviews' do
    book = create(:book)
    visit book_path(book)

    within '.view-reviews' do
      expect(page).to have_content('None')
    end
  end

  let!(:have_read_book) {
    create(:have_read_book, date_completed: DateTime.current.prev_day)
  }
  let!(:user) { create(:user) }
  let!(:book) { have_read_book.book }
  let!(:date) { have_read_book.created_at }
  let!(:have_read_book2) {
    create(:have_read_book,
      book: book,
      user: user,
      rating: 8,
      created_at: date.prev_day
    )
  }
  let!(:have_read_book3) { create(:have_read_book, book: book, rating: 7) }
  let!(:have_read_book4) { create(:have_read_book, rating: 6) }

  scenario 'only the reviews for a book show on the details page' do
    visit book_path(book)

    expect(page).to have_css("#review-#{have_read_book.id}")
    expect(page).to have_css("#review-#{have_read_book2.id}")
    expect(page).to have_css("#review-#{have_read_book3.id}")
    expect(page).not_to have_css("#review-#{have_read_book4.id}")
  end

  scenario 'reviews ordered newest to oldest with mine first' do
    visit book_path(book)

    within '.view-reviews' do
      expect(first('li')).to have_content("#{have_read_book2.rating} out of 10")
      expect(all('li')[1]).to have_content("#{have_read_book3.rating} out of 10")
      expect(all('li')[2]).to have_content("#{have_read_book.rating} out of 10")
    end
  end

  scenario 'my review appears in the review form' do
    visit book_path(book)

    expect(page).to have_content("#{have_read_book2.rating} out of 10", count: 2)
  end

  scenario 'view rating on have_read_books list' do
    visit have_read_books_path

    expect(page).to have_content("#{have_read_book2.rating} out of 10", count: 1)
    expect(page).not_to have_content("#{have_read_book.rating} out of 10")
  end

  scenario 'view rating on browse page' do
    visit books_path

    expect(page).to have_content("My Rating: #{have_read_book2.rating} out of 10", count: 1)
  end
end
