require 'rails_helper'

feature 'user creates a review for a book' do
  before(:each) do
    sign_in user
  end

  let!(:user) { create(:user) }
  let!(:have_read_book) { create(:have_read_book, note: nil, rating: nil) }
  let!(:book) { have_read_book.book }

  # As a user
  # I can review books I have read
  # So that I remember how much I liked them
  #
  # Acceptance Criteria:
  #   A review consists of a rating and optional notes
  #   I can review a book only once using the form on the book details page
  scenario 'add review note to have_read_book' do
    visit book_path(book)
    find('#note').set('asdfjkl')
    click_on 'Submit'

    expect(page).to have_content('Not rated', count: 2)
    expect(page).to have_content('asdfjkl', count: 2)
  end

  scenario 'add rating and review note to have_read_book' do
    visit book_path(book)
    find('#rating').select(9)
    find('#note').set('asdfjkl')
    click_on 'Submit'

    expect(page).to have_content("#{have_read_book.rating} out of 10", count: 2)
    expect(page).to have_content('asdfjkl', count: 2)
  end
end
