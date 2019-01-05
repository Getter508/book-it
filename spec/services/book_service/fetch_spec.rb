require 'rails_helper'

RSpec.describe BookService::Fetch, type: :service do
  describe '#call' do
    it 'returns self when a new page is visited' do
      books = []
      30.times { books << create(:book) }

      service = BookService::Fetch.new(nil, 1)

      expect(service.call).to eq(service)
      expect(service.books).to match_array(books)
      expect(service.updated_cookie).to match_array(books.pluck(:id))
    end

    it 'returns self when an old page is visited' do
      books = []
      30.times { books << create(:book) }
      cookie = books.pluck(:id).join('&')

      service = BookService::Fetch.new(cookie, 1)

      expect(service.call).to eq(service)
      expect(service.books).to eq(books)
      expect(service.updated_cookie).to eq(books.pluck(:id))
    end
  end

  describe '#new_page_visited?' do
    it 'returns true if ids_in_question include 0' do
      cookie = (Array.new(30, 0) + (1..30).to_a).join('&')
      service = BookService::Fetch.new(cookie, 1)

      expect(service.new_page_visited?).to be true
    end

    it 'returns true if the first index is larger than or equal to the number of used ids' do
      cookie = (1..30).to_a.join('&')
      service = BookService::Fetch.new(cookie, 2)

      expect(service.new_page_visited?).to be true
    end

    it 'returns false if none of the ids are 0 and the first index is smaller than the number of used ids' do
      cookie = (1..30).to_a.join('&')
      service = BookService::Fetch.new(cookie, 1)

      expect(service.new_page_visited?).to be false
    end
  end

  describe '#ids_in_question' do
    it 'returns the book ids of a previously viewed page' do
      cookie = (1..30).to_a.join('&')
      service = BookService::Fetch.new(cookie, 1)

      expect(service.ids_in_question).to eq((1..30).to_a)
    end
  end

  describe '#fetch_used_ids' do
    it 'returns an empty array if cookie is nil' do
      service = BookService::Fetch.new(nil, 1)

      expect(service.fetch_used_ids).to eq([])
    end

    it 'returns an empty array if cookie is empty' do
      service = BookService::Fetch.new([], 1)

      expect(service.fetch_used_ids).to eq([])
    end

    it 'returns an array of used ids if cookie is present' do
      service = BookService::Fetch.new('1&2&3', 1)

      expect(service.fetch_used_ids).to eq([1, 2, 3])
    end
  end

  describe '#first_index' do
    it 'returns the first index of the page' do
      service = BookService::Fetch.new(nil, 2)

      expect(service.first_index).to eq(30)
    end
  end

  describe '#add_book_ids' do
    context 'the first index is larger than or equal to the number of used ids' do
      it 'adds book ids to the used ids' do
        books = []
        30.times { books << create(:book) }

        service = BookService::Fetch.new(nil, 1)
        service.instance_variable_set(:@books, books)
        service.add_book_ids

        expect(service.instance_variable_get(:@used_ids)).to eq(books.pluck(:id).to_a)
      end

      it 'adds book ids and some number of zeros to the used ids' do
        books = []
        30.times { books << create(:book) }

        service = BookService::Fetch.new(nil, 2)
        service.instance_variable_set(:@books, books)
        service.add_book_ids

        expect(service.instance_variable_get(:@used_ids)).to eq(Array.new(30, 0) + books.pluck(:id).to_a)
      end
    end

    context 'the first index is smaller than the number of used ids' do
      it 'overwrites the placeholder (0) with randomly selected book ids' do
        books = []
        30.times { books << create(:book) }
        cookie = (Array.new(30, 0) + (1..30).to_a).join('&')

        service = BookService::Fetch.new(cookie, 1)
        service.instance_variable_set(:@books, books)
        service.add_book_ids

        expect(service.instance_variable_get(:@used_ids)).to eq(books.pluck(:id).to_a + (1..30).to_a)
      end
    end
  end

  describe '#determine_indices_in_question' do
    it 'returns an array of 0 to 30 if page is 1' do
      service = BookService::Fetch.new(nil, 1)

      expect(service.determine_indices_in_question).to eq((0...30).to_a)
    end

    it 'returns an array of 30 to 60 if page is 2' do
      service = BookService::Fetch.new(nil, 2)

      expect(service.determine_indices_in_question).to eq((30...60).to_a)
    end
  end
end
