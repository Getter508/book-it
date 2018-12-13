require 'rails_helper'

feature 'user deletes a review for a book' do
  before(:each) do
    sign_in user
  end

  let!(:user) { create(:user) }
  let!(:have_read_book) { create(:have_read_book, user: user, rating: 6) }
  let!(:book) { have_read_book.book }

  # As the creator of a review
  # I can delete my review of a book
  # So that my opinion is no longer public
  #
  # Acceptance Criteria:
  #   No other users can delete my reviews
  #   If I click 'Delete' on the review form, I receive an alert of success
  scenario 'deletes review' do
    visit book_path(book)
    click_on 'Delete'

    expect(page).to have_content('Your review has been deleted')
    expect(page).not_to have_content('out of 10')
    expect(page).not_to have_content('Great book')
  end
end
