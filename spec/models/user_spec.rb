require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#update_ranks' do
    it 'returns true if old rank and new rank are both nil' do
      to_read_book = create(:to_read_book)
      user = to_read_book.user
      book = to_read_book.book

      expect(user.update_ranks(book_id: book.id, old_rank: nil, new_rank: nil)).to be true
    end

    it 'adds one to rank if old rank is nil and new rank is present when rank is taken' do
      to_read_book = create(:to_read_book)
      user = to_read_book.user
      book = to_read_book.book
      to_read_book2 = create(:to_read_book, user: user)
      to_read_book3 = create(:to_read_book, user: user, rank: 2)
      to_read_book4 = create(:to_read_book, user: user, rank: 1)
      to_read_book5 = create(:to_read_book, user: user, rank: 4)

      user.update_ranks(book_id: book.id, old_rank: nil, new_rank: 1)

      expect(to_read_book.reload.rank).to eq(1)
      expect(to_read_book2.reload.rank).to be_nil
      expect(to_read_book3.reload.rank).to eq(3)
      expect(to_read_book4.reload.rank).to eq(2)
      expect(to_read_book5.reload.rank).to eq(4)
    end

    it 'subtracts one from rank if old rank is present and new rank is nil' do
      to_read_book = create(:to_read_book, rank: 1)
      user = to_read_book.user
      book = to_read_book.book
      to_read_book2 = create(:to_read_book, user: user)
      to_read_book3 = create(:to_read_book, user: user, rank: 3)
      to_read_book4 = create(:to_read_book, user: user, rank: 2)
      to_read_book5 = create(:to_read_book, user: user, rank: 4)

      user.update_ranks(book_id: book.id, old_rank: to_read_book.rank, new_rank: nil)

      expect(to_read_book.reload.rank).to be_nil
      expect(to_read_book2.reload.rank).to be_nil
      expect(to_read_book3.reload.rank).to eq(2)
      expect(to_read_book4.reload.rank).to eq(1)
      expect(to_read_book5.reload.rank).to eq(3)
    end

    it 'subtracts one from rank between old rank and new rank' do
      to_read_book = create(:to_read_book, rank: 1)
      user = to_read_book.user
      book = to_read_book.book
      to_read_book2 = create(:to_read_book, user: user)
      to_read_book3 = create(:to_read_book, user: user, rank: 3)
      to_read_book4 = create(:to_read_book, user: user, rank: 2)
      to_read_book5 = create(:to_read_book, user: user, rank: 4)

      user.update_ranks(book_id: book.id, old_rank: to_read_book.rank, new_rank: 3)

      expect(to_read_book.reload.rank).to eq(3)
      expect(to_read_book2.reload.rank).to be_nil
      expect(to_read_book3.reload.rank).to eq(2)
      expect(to_read_book4.reload.rank).to eq(1)
      expect(to_read_book5.reload.rank).to eq(4)
    end

    it 'adds one to rank between new rank and old rank if rank is taken' do
      to_read_book = create(:to_read_book, rank: 3)
      user = to_read_book.user
      book = to_read_book.book
      to_read_book2 = create(:to_read_book, user: user)
      to_read_book3 = create(:to_read_book, user: user, rank: 2)
      to_read_book4 = create(:to_read_book, user: user, rank: 1)
      to_read_book5 = create(:to_read_book, user: user, rank: 4)

      user.update_ranks(book_id: book.id, old_rank: to_read_book.rank, new_rank: 1)

      expect(to_read_book.reload.rank).to eq(1)
      expect(to_read_book2.reload.rank).to be_nil
      expect(to_read_book3.reload.rank).to eq(3)
      expect(to_read_book4.reload.rank).to eq(2)
      expect(to_read_book5.reload.rank).to eq(4)
    end
  end
end
