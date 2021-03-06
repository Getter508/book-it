require 'rails_helper'

feature 'user views books' do
  describe 'view books' do
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

    # As an unauthenticated user
    # I can browse for books
    # So that I can get book ideas
    #
    # Acceptance Criteria:
    #   Page displays book cover, title, author, genre, and synopsis
    #   Books can be filtered by genre
    #   Books can be sorted by title or author
    #   Books are paginated (by 30s)
    scenario 'browses all books' do
      visit books_path

      expect(page).to have_content(book1.title)
      expect(page).to have_content(book2.title)
      expect(page).to have_content(book_author1.author.name)
      expect(page).to have_content(book_author2.author.name)
      expect(page).to have_content(book_genre1.genre.name)
      expect(page).to have_content(book1.description, count: 2)
      expect(page).to have_xpath('//img[contains(@src,"8259447-L.jpg")]')
      expect(page).to have_xpath('//img[contains(@src,"8155423-L.jpg")]')
    end

    scenario 'sort books by title' do
      visit books_path
      click_on('Title')

      within 'ul.books-list' do
        expect(first('li')).to have_content(book1.title)
        expect(all('li')[1]).to have_content(book2.title)
      end

      click_on('Title')

      within 'ul.books-list' do
        expect(first('li')).to have_content(book2.title)
        expect(all('li')[1]).to have_content(book1.title)
      end
    end

    scenario 'sort books by author' do
      visit books_path
      click_on('Author')

      within 'ul.books-list' do
        expect(first('li')).to have_content(book_author1.author.name)
        expect(all('li')[1]).to have_content(book_author2.author.name)
      end

      click_on('Author')

      within 'ul.books-list' do
        expect(first('li')).to have_content(book_author2.author.name)
        expect(all('li')[1]).to have_content(book_author1.author.name)
      end
    end

    scenario 'filter books by genre' do
      visit books_path
      find('#genre_id').find(:xpath, 'option[3]').select_option
      click_on('Filter')

      expect(page).to have_content(book1.title)
      expect(page).not_to have_content(book2.title)

      click_on('Remove')

      expect(page).to have_content(book1.title)
      expect(page).to have_content(book2.title)
    end

    # As a user
    # I can view details of a book
    # So that I know more about it
    #
    # Acceptance Criteria:
    #   I am directed to sign in or sign up if I am not already signed in
    #   If I click a book cover, I am taken to the details page if I am signed in
    #   This page displays book cover, title, genre, year, author, synopsis, and
    #     overall rating
    scenario 'tries to view book details before signing in' do
      visit books_path
      find(".book-#{book1.id}").click

      expect(page).to have_content('You need to sign in or sign up before continuing')
      expect(page).not_to have_content(book1.title)
    end

    scenario 'view book details' do
      user = create(:user)
      sign_in user
      visit books_path
      find(".book-#{book1.id}").click

      expect(page).to have_content(book1.title)
      expect(page).to have_content(book1.year)
      expect(page).to have_content(book1.pages)
      expect(page).to have_content(book1.description)
      expect(page).to have_content(book_author1.author.name)
      expect(page).to have_content(book_genre1.genre.name)
      expect(page).to have_xpath('//img[contains(@src,"8259447-L.jpg")]')
      expect(page).not_to have_content(book2.title)
      expect(page).not_to have_content(book2.authors.first.name)
      expect(page).not_to have_content(book_genre2.genre.name)
      expect(page).not_to have_xpath('//img[contains(@src,"8155423-L.jpg")]')
    end
  end

  describe 'view consistently, randomly selected books' do
    scenario 'same books appear on a page when revisited' do
      books = []
      60.times { books << create(:book) }

      visit books_path
      first_visit_ids = page.all(:css, '.index-buttons').pluck(:id)
      visit books_path
      second_visit_ids = page.all(:css, '.index-buttons').pluck(:id)

      expect(first_visit_ids).to eq(second_visit_ids)
    end

    scenario 'each page displays different books from the others' do
      books = []
      60.times { books << create(:book) }

      visit books_path
      first_page_ids = page.all(:css, '.index-buttons').pluck(:id)
      click_on(2)
      second_page_ids = page.all(:css, '.index-buttons').pluck(:id)

      expect(second_page_ids - first_page_ids).to eq(second_page_ids)
    end
  end
end
