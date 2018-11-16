require 'rails_helper'

feature "user views 'to read' books" do
  before(:each) do
    sign_in user
  end

  let!(:book_author1) { create(:book_author) }
  let!(:book1) { book_author1.book }
  let!(:book_genre1) { create(:book_genre, book: book1) }
  let!(:to_read_book1) { create(:to_read_book, book: book1, rank: 2) }
  let!(:user) { to_read_book1.user }
  let!(:book2) {
    create(:book,
    title: "The Wise Man's Fear",
    cover: "http://covers.openlibrary.org/b/id/8155423-L.jpg")
  }
  let!(:book_author2) { create(:book_author, book: book2) }
  let!(:to_read_book2) { create(:to_read_book, book: book2, user: user, rank: 1) }
  let!(:book_author3) { create(:book_author) }
  let!(:book3) { book_author3.book }

  # As a user
  # I can view a list of the books I want to read
  # So that I can select one
  #
  # Acceptance Criteria:
  #   All books added to 'To Read' appear on this page
  #   Sort by ranking (default), title, or author
  #   I can access the details page by clicking the book cover here
  scenario "view 'to read' list" do
    visit to_read_books_path

    within "ul.to_read_books" do
      expect(first('li')).to have_content(book2.title)
      expect(first('li')).to have_content(to_read_book2.rank)
      expect(first('li')).to have_content(book_author2.author.name)
      expect(first('li')).to have_xpath("//img[contains(@src,'8155423-L.jpg')]")
      expect(all('li')[1]).to have_content(book1.title)
      expect(all('li')[1]).to have_content(to_read_book1.rank)
      expect(all('li')[1]).to have_content(book_author1.author.name)
      expect(all('li')[1]).to have_xpath("//img[contains(@src,'8259447-L.jpg')]")
    end
    expect(page).not_to have_content(book3.title)
    expect(page).not_to have_content(book_author3.author.name)
  end

  scenario "sort books by title" do
    visit to_read_books_path
    click_on("Title")

    within "ul.to_read_books" do
      expect(first('li')).to have_content(book1.title)
      expect(all('li')[1]).to have_content(book2.title)
    end

    click_on("Title")

    within "ul.to_read_books" do
      expect(first('li')).to have_content(book2.title)
      expect(all('li')[1]).to have_content(book1.title)
    end
  end

  scenario "sort books by author" do
    visit to_read_books_path
    click_on("Author")

    within "ul.to_read_books" do
      expect(first('li')).to have_content(book_author1.author.name)
      expect(all('li')[1]).to have_content(book_author2.author.name)
    end

    click_on("Author")

    within "ul.to_read_books" do
      expect(first('li')).to have_content(book_author2.author.name)
      expect(all('li')[1]).to have_content(book_author1.author.name)
    end
  end

  scenario "sort books by rank" do
    visit to_read_books_path
    click_on("My Ranking")

    within "ul.to_read_books" do
      expect(first('li')).to have_content(book2.title)
      expect(all('li')[1]).to have_content(book1.title)
    end
  end

  scenario "view book details" do
    visit to_read_books_path
    find(".book-#{book1.id}").click

    expect(page).to have_content(book1.year)
    expect(page).to have_content(book1.pages)
    expect(page).not_to have_content(book2.title)
  end
end
