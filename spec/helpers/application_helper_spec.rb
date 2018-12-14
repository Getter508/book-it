require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:current_user) { create(:user) }
  before(:each) do
    allow(helper).to receive(:current_user).and_return(current_user)
  end

  describe '#sortable' do
    it 'returns a link when attribute is title and direction is nil' do
      params = { sort: 'author', direction: nil, controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('title')

      expect(link).to eq('<a href="/to_read_books?direction=asc&amp;sort=title">Title</a>')
    end

    it 'returns a link when attribute is author and direction is nil' do
      params = { sort: 'title', direction: nil, controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('author')

      expect(link).to eq('<a href="/to_read_books?direction=asc&amp;sort=author">Author</a>')
    end

    it 'returns a link when attribute is title and direction is asc' do
      params = { sort: 'author', direction: 'asc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('title')

      expect(link).to eq('<a href="/to_read_books?direction=desc&amp;sort=title">Title</a>')
    end

    it 'returns a link when attribute is author and direction is asc' do
      params = { sort: 'title', direction: 'asc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('author')

      expect(link).to eq('<a href="/to_read_books?direction=desc&amp;sort=author">Author</a>')
    end

    it 'returns a link when attribute is title and direction is desc' do
      params = { sort: 'author', direction: 'desc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('title')

      expect(link).to eq('<a href="/to_read_books?direction=asc&amp;sort=title">Title</a>')
    end

    it 'returns a link when attribute is author and direction is desc' do
      params = { sort: 'title', direction: 'asc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('author')

      expect(link).to eq('<a href="/to_read_books?direction=desc&amp;sort=author">Author</a>')
    end

    it 'returns a link with class when attribute is title and direction is asc' do
      params = { sort: 'title', direction: 'asc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('title')

      expect(link).to eq('<a class="current asc" href="/to_read_books?direction=desc&amp;sort=title">Title</a>')
    end

    it 'returns a link with class when attribute is author and direction is asc' do
      params = { sort: 'author', direction: 'asc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('author')

      expect(link).to eq('<a class="current asc" href="/to_read_books?direction=desc&amp;sort=author">Author</a>')
    end

    it 'returns a link with class when attribute is title and direction is desc' do
      params = { sort: 'title', direction: 'desc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('title')

      expect(link).to eq('<a class="current desc" href="/to_read_books?direction=asc&amp;sort=title">Title</a>')
    end

    it 'returns a link with class when attribute is author and direction is desc' do
      params = { sort: 'author', direction: 'desc', controller: 'to_read_books' }
      allow(helper).to receive(:params).and_return(params)
      link = helper.sortable('author')

      expect(link).to eq('<a class="current desc" href="/to_read_books?direction=asc&amp;sort=author">Author</a>')
    end
  end

  describe '#selected_month' do
    it 'returns the current 3-letter month if have_read_book is nil' do
      have_read_book = nil

      expect(helper.selected_month(have_read_book)).to eq("#{Time.zone.now.strftime('%b')}")
    end

    it 'returns the current 3-letter month if have_read_book date_completed is nil' do
      have_read_book = create(:have_read_book, date_completed: nil)

      expect(helper.selected_month(have_read_book)).to eq("#{Time.zone.now.strftime('%b')}")
    end

    it 'returns the 3-letter month of have_read_book date_completed' do
      have_read_book = create(:have_read_book, date_completed: DateTime.parse('Nov 7, 2017'))

      expect(helper.selected_month(have_read_book)).to eq('Nov')
    end
  end

  describe '#selected_day' do
    it 'returns the current day if have_read_book is nil' do
      have_read_book = nil
      day = Time.zone.now.day

      expect(helper.selected_day(have_read_book)).to eq(day)
    end

    it 'returns the current day if have_read_book date_completed is nil' do
      have_read_book = create(:have_read_book, date_completed: nil)
      day = Time.zone.now.day

      expect(helper.selected_day(have_read_book)).to eq(day)
    end

    it 'returns the day of have_read_book date_completed' do
      have_read_book = create(:have_read_book, date_completed: DateTime.parse('Nov 7, 2017'))

      expect(helper.selected_day(have_read_book)).to eq(7)
    end
  end

  describe '#selected_year' do
    it 'returns the current year if have_read_book is nil' do
      have_read_book = nil
      year = Time.zone.now.year

      expect(helper.selected_year(have_read_book)).to eq(year)
    end

    it 'returns the current year if have_read_book date_completed is nil' do
      have_read_book = create(:have_read_book, date_completed: nil)
      year = Time.zone.now.year

      expect(helper.selected_year(have_read_book)).to eq(year)
    end

    it 'returns the year of have_read_book date_completed' do
      have_read_book = create(:have_read_book, date_completed: DateTime.parse('Nov 7, 2017'))

      expect(helper.selected_year(have_read_book)).to eq(2017)
    end
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

  describe '#is_active?' do
    it 'returns nil if book_list is empty' do
      book_list = nil

      expect(helper.is_active?(book_list)).to be_nil
    end

    it 'returns "is-active" if book_list is present' do
      book_list = 'books'

      expect(helper.is_active?(book_list)).to eq('is-active')
    end
  end

  describe '#color' do
    it 'returns warning if review user is the current user' do
      have_read_book = create(:have_read_book, user: current_user)

      expect(helper.color(have_read_book)).to eq('warning')
    end

    it 'returns secondary if review user is not the current user' do
      have_read_book = create(:have_read_book)

      expect(helper.color(have_read_book)).to eq('secondary')
    end
  end
end
