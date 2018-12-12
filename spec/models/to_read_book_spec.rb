require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#decrement_rank!' do
    it 'decreases rank by one' do
      to_read_book = create(:to_read_book, rank: 6)

      to_read_book.decrement_rank!

      expect(to_read_book.rank).to eq(5)
    end
  end

  describe '#increment_rank!' do
    it 'increases rank by one if rank is less than the max rank' do
      to_read_book = create(:to_read_book, rank: 6)

      to_read_book.increment_rank!

      expect(to_read_book.rank).to eq(7)
    end

    it 'sets rank to nil if rank is greater than or equal to the max rank' do
      to_read_book = create(:to_read_book, rank: 10)

      to_read_book.increment_rank!

      expect(to_read_book.rank).to be_nil
    end
  end
end
