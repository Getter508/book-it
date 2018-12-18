require 'rails_helper'

RSpec.describe Book, type: :service do
  describe '#ratio' do
    it 'returns the decimal value of height / width' do
      book_cover = BookImporterService::BookCover.create(178250)
      height = book_cover.height.to_f
      width = book_cover.width.to_f

      expect(book_cover.ratio).to eq(height/width)
    end
  end

  describe '#qualifies?' do
    it 'returns false if the ratio is too large' do
      book_cover = BookImporterService::BookCover.create(106039)

      expect(book_cover.qualifies?).to be false
    end

    it 'returns false if the ratio is too small' do
      book_cover = BookImporterService::BookCover.create(534835)

      expect(book_cover.qualifies?).to be false
    end

    it 'returns false if the height is too small' do
      book_cover = BookImporterService::BookCover.create(2419829)

      expect(book_cover.qualifies?).to be false
    end

    it 'returns false if width is too small' do
      book_cover = BookImporterService::BookCover.create(2578963)

      expect(book_cover.qualifies?).to be false
    end


    it 'returns true if it meets the criteria' do
      book_cover = BookImporterService::BookCover.create(2835973)

      expect(book_cover.qualifies?).to be true
    end
  end
end
