require 'rails_helper'

RSpec.describe Book, type: :service do
  describe '#image_size' do
    it 'returns the size array' do
      allow(FastImage).to receive(:size).and_return([286, 475])
      book_cover = BookImporterService::BookCover.create(106039)

      expect(book_cover.width).to eq(286)
      expect(book_cover.height).to eq(475)
    end

    it 'returns nil after 5 attempts' do
      allow(FastImage).to receive(:size).and_return(nil)
      book_cover = BookImporterService::BookCover.create(123456)

      expect(book_cover.width).to be nil
      expect(book_cover.height).to be nil
    end
  end

  describe '#ratio' do
    it 'returns the decimal value of height / width' do
      allow(FastImage).to receive(:size).and_return([319, 475])
      book_cover = BookImporterService::BookCover.create(178250)
      height = book_cover.height.to_f
      width = book_cover.width.to_f

      expect(book_cover.ratio).to eq(height/width)
    end

    it 'returns 0 if width is nil' do
      allow(FastImage).to receive(:size).and_return([nil, 475])
      book_cover = BookImporterService::BookCover.create(654321)

      expect(book_cover.ratio).to eq(0)
    end

    it 'returns 0 if height is nil' do
      allow(FastImage).to receive(:size).and_return([319, nil])
      book_cover = BookImporterService::BookCover.create(654321)

      expect(book_cover.ratio).to eq(0)
    end

    it 'returns 0 if width is 0' do
      allow(FastImage).to receive(:size).and_return([319, 0])
      book_cover = BookImporterService::BookCover.create(654321)

      expect(book_cover.ratio).to eq(0)
    end
  end

  describe '#qualifies?' do
    it 'returns false if the ratio is too large' do
      allow(FastImage).to receive(:size).and_return([286, 475])
      book_cover = BookImporterService::BookCover.create(106039)

      expect(book_cover.qualifies?).to be false
    end

    it 'returns false if the ratio is too small' do
      allow(FastImage).to receive(:size).and_return([405, 475])
      book_cover = BookImporterService::BookCover.create(534835)

      expect(book_cover.qualifies?).to be false
    end

    it 'returns false if the height is too small' do
      allow(FastImage).to receive(:size).and_return([475, 237])
      book_cover = BookImporterService::BookCover.create(2419829)

      expect(book_cover.qualifies?).to be false
    end

    it 'returns false if width is too small' do
      allow(FastImage).to receive(:size).and_return([250, 390])
      book_cover = BookImporterService::BookCover.create(2578963)

      expect(book_cover.qualifies?).to be false
    end

    it 'returns true if it meets the criteria' do
      allow(FastImage).to receive(:size).and_return([333, 500])
      book_cover = BookImporterService::BookCover.create(2835973)

      expect(book_cover.qualifies?).to be true
    end
  end
end
