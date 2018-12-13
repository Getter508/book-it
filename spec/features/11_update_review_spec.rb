require 'rails_helper'

feature 'user updates a review for a book' do
  before(:each) do
    sign_in user
  end

  let!(:user) { create(:user) }
  let!(:have_read_book) { create(:have_read_book, user: user, rating: 6) }
  let!(:book) { have_read_book.book }

  # As the creator of a review
  # I can edit my review of a book
  # So that I can update my opinion
  #
  # Acceptance Criteria:
  #   No other users can edit my reviews
  #   If I click 'Edit', I can access a form with prefilled fields
  #   If I 'Cancel' my edit, the previous information appears
  #   If I edit a rating, I receive an alert of success
  #   If the info is insufficient, I receive an error alert and the form retains
  #     the previously supplied info
  scenario 'successfully updates review' do
    visit book_path(book)
    click_on 'Edit'
    find('#rating').select(7)
    find('#note').set('asdfjkl')
    click_on 'Submit'

    expect(page).to have_content('7 out of 10', count: 2)
    expect(page).to have_content('asdfjkl', count: 2)
    expect(page).not_to have_content('6 out of 10')
    expect(page).not_to have_content('Great book')
  end

  scenario 'fails to update a review' do
    allow_any_instance_of(HaveReadBook).to receive(:save).and_return(false)
    visit book_path(book)
    click_on 'Edit'
    find('#rating').select(7)
    find('#note').set('asdfjkl')
    click_on 'Submit'

    expect(page).to have_content('Have Read book failed to update')
    expect(page).not_to have_content('7 out of 10', count: 2)
    expect(page).not_to have_content('asdfjkl', count: 2)
  end
end
