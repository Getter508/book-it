require 'rails_helper'

RSpec.describe ApplicationHelper do
  let(:current_user) { create(:user) }
  before(:each) do
    allow(helper).to receive(:current_user).and_return(current_user)
  end

  describe '#have_read' do
    it 'returns nil if no one has read this book' do
      book = create(:book)

      expect(helper.have_read(book)).to be_nil
    end

    it 'returns nil if user has not read this book' do
      have_read_book = create(:have_read_book)
      book = have_read_book.book

      expect(helper.have_read(book)).to be_nil
    end

    it 'returns the have_read_book for the current user' do
      have_read_book = create(:have_read_book, user: current_user)
      book = have_read_book.book

      expect(helper.have_read(book)).to eq(have_read_book)
    end
  end

  describe '#to_read' do
    it 'returns nil if no one wants to read this book' do
      book = create(:book)

      expect(helper.to_read(book)).to be_nil
    end

    it 'returns nil if user does not want to read this book' do
      to_read_book = create(:to_read_book)
      book = to_read_book.book

      expect(helper.to_read(book)).to be_nil
    end

    it 'returns the to_read_book for the current user' do
      to_read_book = create(:to_read_book, user: current_user)
      book = to_read_book.book

      expect(helper.to_read(book)).to eq(to_read_book)
    end
  end
end
