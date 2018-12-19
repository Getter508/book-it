require 'rails_helper'

feature 'user searches books' do
  before(:each) do
    sign_in user
  end

  let!(:user) { create(:user) }
  let!(:book1) { create(:book, title: 'The Name of the Wind2') }
  let!(:book2) { create(:book, title: 'The Name of the Wind1') }
  let!(:book3) { create(:book, title: 'The Name of the Wind3') }
  let!(:book4) { create(:book, title: 'Foundation') }

  # As a user
  # I can search for books
  # So that I can find specific books I am interested in
  #
  # Acceptance Criteria:
  #   I can search by title or author
  #   Book results are paginated
  #   Book results are ordered by title or by author name then title
  scenario 'search for books by title' do
    visit books_path
    find('#category').select('Title')
    find('#search').set('Name of the Wind')
    click_on 'Search'

    expect(page).to have_content('Search results')
    expect(page).to have_content('3 matches found')
    expect(page).not_to have_content(book4.title)
    within '.books-list' do
      expect(first('li')).to have_content(book2.title)
      expect(all('li')[1]).to have_content(book1.title)
      expect(all('li')[2]).to have_content(book3.title)
    end
  end

  scenario 'search for books by author' do
    author1 = create(:author, name: 'Patrick Rothfuss Jr.')
    author2 = create(:author, name: 'Patrick Rothfuss')
    author3 = create(:author, name: 'Isaac Asimov')
    book_author1 = create(:book_author, book: book1, author: author1)
    book_author2 = create(:book_author, book: book2, author: author2)
    book_author3 = create(:book_author, book: book3, author: author2)
    book_author4 = create(:book_author, book: book4, author: author3)

    visit books_path
    find('#category').select('Author')
    find('#search').set('Rothfuss')
    click_on 'Search'

    expect(page).to have_content('Search results')
    expect(page).to have_content('3 matches found')
    expect(page).not_to have_content(book4.title)
    within '.books-list' do
      expect(first('li')).to have_content(book2.title)
      expect(all('li')[1]).to have_content(book3.title)
      expect(all('li')[2]).to have_content(book1.title)
    end
  end

  scenario 'no books are returned' do
    visit books_path
    find('#search').set('White Christmas')
    click_on 'Search'

    expect(page).to have_content('Search results')
    expect(page).to have_content('No matches found')
    expect(page).not_to have_content(book1.title)
    expect(page).not_to have_content(book2.title)
    expect(page).not_to have_content(book3.title)
    expect(page).not_to have_content(book4.title)
  end
end
