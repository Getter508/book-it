require 'rails_helper'

feature "user deletes 'to read' book" do
  before(:each) do
    sign_in user
  end

  let!(:book_author1) { create(:book_author) }
  let!(:book1) { book_author1.book }
  let!(:to_read_book1) { create(:to_read_book, book: book1, rank: 1) }
  let!(:user) { to_read_book1.user }
  let!(:book_author2) { create(:book_author) }
  let!(:book2) { book_author2.book }
  let!(:to_read_book2) { create(:to_read_book, user: user, book: book2, rank: 2) }

  # As a user
  # I can delete books from my To Read list
  # So that I no longer have to read them
  #
  # Acceptance Criteria:
  #   To Read book is removed from list when clicking delete
  #   I receive a notification of success
  scenario "successfully deletes a To Read book" do
    visit to_read_books_path
    find("#delete-to-read-#{book1.id}").click

    expect(page).to have_content("Book removed from your To Read list")
    expect(page).to have_content(book2.title)
    expect(page).not_to have_content(book1.title)
  end
end
