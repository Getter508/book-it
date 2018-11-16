require 'rails_helper'

feature "user views 'have read' books" do
  let!(:book_author1) { create(:book_author) }
  let!(:book1) { book_author1.book }
  let!(:book_genre1) { create(:book_genre, book: book1) }
  let!(:have_read_book1) { create(:have_read_book, book: book1) }
  let!(:user) { :have_read_book1.user }
  let!(:book2) {
    create(:book,
    title: "The Wise Man's Fear",
    cover: "http://covers.openlibrary.org/b/id/8155423-L.jpg")
  }
  let!(:book_author2) { create(:book_author, book: book2) }
  # let!(:genre2) { create(:genre, name: "Adventure") }
  # let!(:book_genre2) { create(:book_genre, book: book2, genre: genre2) }
  let!(:have_read_book2) {
    create(:have_read_book,
      book: book2,
      user: user,
      date_completed: DateTime.current.prev_day)
  }
  let!(:book_author3) { create(:book_author)}
  let!(:book3) { book_author3.book }

  # As a user
  # I can view the books I have read
  # So that I can track my readings
  #
  # Acceptance Criteria:
  #   All books marked read appear on the 'Have Read' page
  #   Books can be sorted by title, author, or when they were read
  #   I can access the details page by clicking the book cover here
  scenario "view 'have read' list" do
    visit have_read_books_path

    expect(page).to have_content(book1.title)
    expect(page).to have_content(book_author1.author.name)
    expect(page).to have_xpath("//img[contains(@src,'8259447-L.jpg')]")
    expect(page).to have_content(book2.title)
    expect(page).to have_content(book_author2.author.name)
    expect(page).to have_xpath("//img[contains(@src,'8155423-L.jpg')]")
    expect(page).not_to have_content(book3.title)
    expect(page).not_to have_content(book_author3.author.name)
  end

  xscenario "sort books by title" do
    # visit have_read_books_path
    # click_on("Title")
    #
    # within "ul.books" do
    #   expect(first('li')).to have_content(book1.title)
    #   expect(all('li')[1]).to have_content(book2.title)
    # end
    #
    # click_on("Title")
    #
    # within "ul.books" do
    #   expect(first('li')).to have_content(book2.title)
    #   expect(all('li')[1]).to have_content(book1.title)
    # end
  end

  xscenario "sort books by author" do
    # visit have_read_books_path
    # click_on("Author")
    #
    # within "ul.books" do
    #   expect(first('li')).to have_content(book_author1.author.name)
    #   expect(all('li')[1]).to have_content(book_author2.author.name)
    # end
    #
    # click_on("Author")
    #
    # within "ul.books" do
    #   expect(first('li')).to have_content(book_author2.author.name)
    #   expect(all('li')[1]).to have_content(book_author1.author.name)
    # end
  end

  xscenario "sort books by date read" do
    # visit have_read_books_path
    # click_on("Author")
    #
    # within "ul.books" do
    #   expect(first('li')).to have_content(book_author1.author.name)
    #   expect(all('li')[1]).to have_content(book_author2.author.name)
    # end
    #
    # click_on("Author")
    #
    # within "ul.books" do
    #   expect(first('li')).to have_content(book_author2.author.name)
    #   expect(all('li')[1]).to have_content(book_author1.author.name)
    # end
  end

  xscenario "view book details" do
    visit have_read_books_path
    # find(".book-#{book1.id}").click

    expect(page).to have_content(book1.year)
    expect(page).to have_content(book1.pages)
    expect(page).not_to have_content(book2.title)
  end
end