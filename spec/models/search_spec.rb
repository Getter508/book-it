require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#call' do
    let!(:book1) { create(:book, title: 'The Name of the Wind2') }
    let!(:book2) { create(:book, title: 'The Name of the Wind1') }
    let!(:book3) { create(:book, title: 'The Name of the Wind3') }
    let!(:book4) { create(:book, title: 'Foundation') }

    it 'returns an error if search query is too short' do
      query = { search: 'as', category: 'Title' }

      expect { Search.run(query) }.to raise_error(Search::InvalidSearchError)
    end

    it 'returns an alphabetized list of books if book title matches' do
      query = { search: 'Name of the', category: 'Title' }

      expect(Search.run(query)).to eq([book2, book1, book3])
    end

    it 'returns an alphabetized list of books if author name matches' do
      query = { search: 'Rothfuss', category: 'Author' }
      author1 = create(:author, name: 'Patrick Rothfuss Jr.')
      author2 = create(:author, name: 'Patrick Rothfuss')
      author3 = create(:author, name: 'Isaac Asimov')
      book_author1 = create(:book_author, book: book1, author: author1)
      book_author2 = create(:book_author, book: book2, author: author2)
      book_author3 = create(:book_author, book: book3, author: author2)
      book_author4 = create(:book_author, book: book4, author: author3)

      expect(Search.run(query)).to eq([book2, book3, book1])
    end

    it 'returns an empty array if search query is valid but no books match' do
      query = { search: 'Rainbow', category: 'Title' }

      expect(Search.run(query)).to eq([])
    end
  end
end
