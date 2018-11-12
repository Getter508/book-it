require 'rails_helper'

feature 'user views books' do

  let!(:book1) { FactoryBot.create(:book) }
  let!(:book2) {
    FactoryBot.create(:book,
    title: "The Wise Man's Fear",
    cover: "http://covers.openlibrary.org/b/id/8155423-L.jpg")
  }
  let!(:book_author1) { FactoryBot.create(:book_author, book: book1) }
  let!(:book_author2) { FactoryBot.create(:book_author, book: book2) }
  let!(:book_genre1) { FactoryBot.create(:book_genre, book: book1) }
  let!(:genre2) { FactoryBot.create(:genre, name: "Adventure") }
  let!(:book_genre2) { FactoryBot.create(:book_genre, book: book2, genre: genre2) }

  # As an unauthenticated user
  # I can browse for books
  # So that I can get book ideas
  #
  # Acceptance Criteria:
  #   Books can be filtered by genre or author
  #   Books can be sorted by title or author
  #   Books are paginated (by 30s)
  scenario "browses all books" do
    visit books_path

    expect(page).to have_content(book_author1.book.title)
    expect(page).to have_content(book2.title)
    expect(page).to have_content(book_author1.author.name)
    expect(page).to have_content(book_author2.author.name)
    expect(page).to have_content(book_genre1.genre.name)
    expect(page).to have_content("So begins the tale of Kvothe.", count: 2)
    expect(page).to have_xpath("//img[contains(@src,'8259447-L.jpg')]")
    expect(page).to have_xpath("//img[contains(@src,'8155423-L.jpg')]")
  end

  # As a user
  # I can view details of a book
  # So that I know more about it
  #
  # Acceptance Criteria:
  #   If I click a book cover, I am taken to the details page
  #   This page displays book cover, title, genre, year, author, synopsis, and
  #     overall rating
  scenario "view book details" do
    visit books_path
    # find(:xpath, "//img[contains(@src,'8259447-L.jpg')]").click
    binding.pry
    click_on book_path(book1)

    expect(page).to have_content(book_author1.book.title)
    expect(page).to have_content(book_author1.book.year)
    expect(page).to have_content(book_author1.book.pages)
    expect(page).to have_content(book_author1.book.description)
    expect(page).to have_content(book_author1.author.name)
    expect(page).to have_content(book_genre1.genre.name)
    expect(page).to have_xpath("//img[contains(@src,'8259447-L.jpg')]")
    expect(page).not_to have_content(book2.book.title)
    expect(page).not_to have_content(book2.author.name)
    expect(page).not_to have_content(bookgenre2.genre.name)
    expect(page).not_to have_xpath("//img[contains(@src,'8155423-L.jpg')]")
  end

end
