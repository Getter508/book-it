require 'rails_helper'

feature 'user updates to_read book' do
  before(:each) do
    sign_in user
  end

  let!(:book_author1) { create(:book_author) }
  let!(:book1) { book_author1.book }
  let!(:to_read_book1) { create(:to_read_book, book: book1, rank: nil) }
  let!(:user) { to_read_book1.user }
  let!(:book_author2) { create(:book_author) }
  let!(:book2) { book_author2.book }
  let!(:to_read_book2) { create(:to_read_book, user: user, book: book2, rank: nil) }

  # As a user
  # I can rank the books I want to read
  # So that they are in the order I prefer
  #
  # Acceptance Criteria:
  #   I can enter a 1-10 ranking for each book of 'To Read' and the list will reorder
  scenario 'successfully adds a rank' do
    visit to_read_books_path
    within(first('.dropdown')) do
      find("#rank-#{book1.id}").select(1)
    end
    within(first('.actions')) do
      click_on('Submit')
    end

    expect(page).to have_content('Rank successfully saved')
    expect(find(:css, "li.to-read-#{book1.id}")).to have_content(book1.title)
    expect(find(:css, "select#rank-#{book1.id}").value).to eq('1')
    expect(find(:css, "li.to-read-#{book2.id}")).to have_content(book2.title)
    expect(find(:css, "select#rank-#{book2.id}").value).to eq('')
  end

  scenario 'fails to add a rank' do
    allow_any_instance_of(ToReadBook).to receive(:save).and_return(false)
    visit to_read_books_path
    within(first('.dropdown')) do
      find("#rank-#{book1.id}").select(1)
    end
    within(first('.actions')) do
      click_on('Submit')
    end

    expect(page).to have_content('Rank failed to update')
    expect(find(:css, "select#rank-#{book1.id}").value).to eq('')
    expect(find(:css, "select#rank-#{book2.id}").value).to eq('')
  end

  scenario 'overwrites rank order' do
    visit to_read_books_path
    within(first('.dropdown')) do
      find("#rank-#{book1.id}").select(1)
    end
    within(first('.actions')) do
      click_on('Submit')
    end

    within(all('.dropdown')[1]) do
      find("#rank-#{book2.id}").select(2)
    end
    within(all('.actions')[2]) do
      click_on('Submit')
    end

    within(all('.dropdown')[1]) do
      find("#rank-#{book2.id}").select(1)
    end
    within(all('.actions')[2]) do
      click_on('Submit')
    end

    expect(page).to have_content('Rank successfully saved')
    expect(find(:css, "select#rank-#{book2.id}").value).to eq('1')
    expect(find(:css, "select#rank-#{book1.id}").value).to eq("2")
    within 'ul.to-read-list' do
      expect(first('li')).to have_content(book2.title)
      expect(all('li')[1]).to have_content(book1.title)
    end
  end
end
