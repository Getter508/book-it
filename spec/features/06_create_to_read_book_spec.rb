require 'rails_helper'

feature 'user tries to add to_read books' do
  before(:each) do
    sign_in user
  end

  let!(:user) { create(:user) }
  let!(:book2) {
    create(:book,
    title: "The Wise Man's Fear",
    cover: 'http://covers.openlibrary.org/b/id/8155423-L.jpg')
  }
  let!(:book_author1) { create(:book_author) }
  let!(:book1) { book_author1.book }
  let!(:book_author2) { create(:book_author, book: book2) }
  let!(:book_genre1) { create(:book_genre, book: book1) }
  let!(:genre2) { create(:genre, name: 'Adventure') }
  let!(:book_genre2) { create(:book_genre, book: book2, genre: genre2) }

  # As a user
  # I can select books I want to read
  # So that I can remember those books
  #
  # Acceptance Criteria:
  #   I can add a book to 'My List' from the browse, search, and show pages
  #   When a book is added, I receive an alert of success and the book is added
  #     to my 'To Read' list
  scenario 'successfully adds a to-read book from browse' do
    visit books_path
    find("#add-to-read-#{book1.id}").click

    expect(page).to have_content('Book successfully added To Read')
    expect(page).to have_content('Filter')

    click_on('To Read')

    expect(page).to have_content('My Ranking')
    expect(page).to have_content(book1.title)
    expect(page).not_to have_content(book2.title)
  end

  scenario 'fails to add a to-red book from browse' do
    allow_any_instance_of(ToReadBook).to receive(:save).and_return(false)
    visit books_path
    find("#add-to-read-#{book1.id}").click

    expect(page).to have_content('Filter')
    expect(page).to have_content('Adding To Read failed')

    click_on('To Read')

    expect(page).not_to have_content(book1.title)
  end

  scenario 'successfully adds a to-read book from details' do
    visit books_path
    find(".book-#{book1.id}").click
    click_on('Add To Read')

    expect(page).to have_content('Filter')
    expect(page).to have_content('Book successfully added To Read')

    click_on('To Read')

    expect(page).to have_content(book1.title)
    expect(page).not_to have_content(book2.title)
  end

  scenario 'fails to add a to-red book from details' do
    allow_any_instance_of(ToReadBook).to receive(:save).and_return(false)
    visit books_path
    find(".book-#{book1.id}").click
    click_on('Add To Read')

    expect(page).to have_content('Filter')
    expect(page).to have_content('Adding To Read failed')

    click_on('To Read')

    expect(page).not_to have_content(book1.title)
  end
end
