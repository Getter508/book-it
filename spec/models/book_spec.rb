require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#display_cover' do
    it 'returns cover if defined' do
      book = create(:book)

      expect(book.display_cover).to eq('http://covers.openlibrary.org/b/id/8259447-L.jpg')
    end

    it 'returns default cover if cover is undefined' do
      book = create(:book, cover: nil)

      expect(book.display_cover).to eq(Book::DEFAULT_COVER)
    end
  end

  describe '#brief_description' do
    it 'returns nil if description is nil' do
      book = create(:book, description: nil)

      expect(book.brief_description).to be_nil
    end

    it 'returns description if description is shorter than or equal to 220 characters' do
      book = create(:book, description: 'Yay')

      expect(book.brief_description).to eq('Yay')
    end

    it 'returns truncated description if description is longer than 220 characters' do
      book = create(:book, description: ('a' * 225))

      expect(book.brief_description).to eq("#{'a' * 221}...")
    end
  end

  describe '#display_genres' do
    it 'returns empty if there are no genres' do
      book = create(:book)

      expect(book.display_genres).to be_empty
    end

    it 'returns a genre if there is one' do
      book_genre = create(:book_genre)
      book = book_genre.book
      genre = book_genre.genre

      expect(book.display_genres).to eq(genre.name)
    end

    it 'returns a list of genres if there are more than one' do
      book_genre = create(:book_genre)
      book = book_genre.book
      genre2 = create(:genre, name: 'Adventure')
      book_genre2 = create(:book_genre, book: book, genre: genre2)
      genre = book_genre.genre

      expect(book.display_genres).to eq("#{genre.name}, #{genre2.name}")
    end
  end

  describe '#display_authors' do
    it 'returns empty if there are no authors' do
      book = create(:book)

      expect(book.display_authors).to be_empty
    end

    it 'returns the author if there is one author' do
      book_author = create(:book_author)
      book = book_author.book
      author = book_author.author

      expect(book.display_authors).to eq(author.name)
    end

    it 'returns authors joined by "&" if there are two authors' do
      book_author = create(:book_author)
      book = book_author.book
      author = book_author.author
      book_author2 = create(:book_author, book: book)
      author2 = book_author2.author

      expect(book.display_authors).to eq("#{author.name} & #{author2.name}")
    end

    it 'returns list of authors if there are more than two' do
      book_author = create(:book_author)
      book = book_author.book
      author = book_author.author
      book_author2 = create(:book_author, book: book)
      author2 = book_author2.author
      book_author3 = create(:book_author, book: book)
      author3 = book_author3.author

      expect(book.display_authors).to eq("#{author.name}, #{author2.name}, #{author3.name}")
    end
  end

  describe '.filter' do
    it 'returns books that have the specified genre' do
      book_genre = create(:book_genre)
      genre2 = create(:genre, name: 'Adventure')
      book_genre2 = create(:book_genre, genre: genre2)
      book2 = book_genre2.book

      expect(Book.filter(genre_id: genre2.id)).to include(book2)
    end
  end

  describe '.order_by' do
    it 'raises an error if sort params are invalid' do
      params = { sort: 'nothing' }

      expect { Book.order_by(params, Book) }.to raise_error(InvalidSortParamError)
    end

    it 'raises an error if direction params are invalid' do
      params = { direction: 'ken' }

      expect { Book.order_by(params, Book) }.to raise_error(InvalidDirectionParamError)
    end

    it 'sorts by default if there are no sort params' do
      params = { direction: 'asc' }
      allow(Book).to receive(:order).with(Arel.sql('random()'))

      Book.order_by(params, Book)

      expect(Book).to have_received(:order).with(Arel.sql('random()'))
    end

    it 'sorts alpahbetically by author if sorted by asc author' do
      book_author = create(:book_author)
      book_author2 = create(:book_author)
      book_author3 = create(:book_author)
      book = book_author.book
      book2 = book_author2.book
      book3 = book_author3.book
      params = { sort: 'author', direction: 'asc' }

      expect(Book.order_by(params, Book)).to eq([book, book2, book3])
    end

    it 'sorts reverse alpahbetically by author if sorted by desc author' do
      book_author = create(:book_author)
      book_author2 = create(:book_author)
      book_author3 = create(:book_author)
      book = book_author.book
      book2 = book_author2.book
      book3 = book_author3.book
      params = { sort: 'author', direction: 'desc' }

      expect(Book.order_by(params, Book)).to eq([book3, book2, book])
    end

    it 'sorts alphabetically by title if sorted by asc title' do
      book_author = create(:book_author)
      book_author2 = create(:book_author)
      book_author3 = create(:book_author)
      book = book_author.book
      book2 = book_author2.book
      book3 = book_author3.book
      params = { sort: 'title', direction: 'asc' }

      expect(Book.order_by(params, Book)).to eq([book, book2, book3])
    end

    it 'sorts reverse alpahbetically by title if sorted by desc title' do
      book_author = create(:book_author)
      book_author2 = create(:book_author)
      book_author3 = create(:book_author)
      book = book_author.book
      book2 = book_author2.book
      book3 = book_author3.book
      params = { sort: 'title', direction: 'desc' }

      expect(Book.order_by(params, Book)).to eq([book3, book2, book])
    end
  end

# moved to application helper as have_read
  # describe '#display_have_read_date' do
  #   it 'returns nil if no one has read this book' do
  #     book = create(:book)
  #     user = create(:user)
  #
  #     expect(book.display_have_read_date(user)).to be_nil
  #   end
  #
  #   it 'returns nil if user has read no books' do
  #     have_read_book = create(:have_read_book)
  #     user = create(:user)
  #     book = have_read_book.book
  #
  #     expect(book.display_have_read_date(user)).to be_nil
  #   end
  #
  #   it 'returns the display date' do
  #     have_read_book = create(:have_read_book)
  #     user = have_read_book.user
  #     book = have_read_book.book
  #
  #     expect(book.display_have_read_date(user)).to eq(have_read_book.display_date)
  #   end
  # end
end
