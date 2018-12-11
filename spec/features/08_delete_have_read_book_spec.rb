require 'rails_helper'

feature "user deletes 'have read' book" do
  before(:each) do
    sign_in user
  end

  let!(:book_author1) { create(:book_author) }
  let!(:book1) { book_author1.book }
  let!(:have_read_book1) { create(:have_read_book, book: book1, rating: 10) }
  let!(:user) { have_read_book1.user }
  let!(:book_author2) { create(:book_author) }
  let!(:book2) { book_author2.book }
  let!(:have_read_book2) {
    create(:have_read_book, user: user, book: book2, rating: 9)
  }

  # As a user
  # I can delete books from my Have Read list
  # So that I can remove books added by mistake
  #
  # Acceptance Criteria:
  #   Have Read book is removed from list when clicking delete
  #   I receive a notification of success
  scenario "successfully deletes a Have Read book" do
    visit have_read_books_path
    find("#delete-have-read-#{book1.id}").click

    expect(page).to have_content("Book removed from your Have Read list")
    expect(page).to have_content(book2.title)
    expect(page).not_to have_content(book1.title)
  end
end
