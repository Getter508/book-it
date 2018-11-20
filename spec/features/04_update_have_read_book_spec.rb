require 'rails_helper'

feature "user updates 'have read' book" do
  before(:each) do
    sign_in user
  end

  let!(:book_author1) { create(:book_author) }
  let!(:book1) { book_author1.book }
  let!(:have_read_book1) { create(:have_read_book, book: book1, date_completed: nil) }
  let!(:user) { have_read_book1.user }

  # As a user
  # I can update the books I have read
  # So that I know when I completed them
  #
  # Acceptance Criteria:
  #   Add date completed form on the 'Have Read' page
  scenario "successfully adds date completed" do
    visit have_read_books_path
    find("#month").select("Nov")
    find("#day").select("8")
    find("#year").select("2018")
    click_on("Submit")

    expect(page).to have_content("11/08/2018")
    expect(page).not_to have_button("Edit")
    expect(page).not_to have_content("Add Date Completed")
  end

  scenario "unsuccessfully adds date completed" do
    visit have_read_books_path
    find("#month").select("Feb")
    find("#day").select("31")
    find("#year").select("2018")
    click_on("Submit")

    expect(page).to have_content("Invalid date")
    expect(page).to have_content("Add Date Completed")
    expect(page).not_to have_content("02/31/2018")
  end

  scenario "updates date completed" do
    visit have_read_books_path
    find("#month").select("Nov")
    find("#day").select("8")
    find("#year").select("2018")
    click_on("Submit")

    click_on("Edit")
    find("#month").select("Oct")
    find("#day").select("7")
    find("#year").select("2017")
    click_on("Submit")

    expect(page).to have_content("Date completed successfully updated")
    expect(page).to have_content("10/07/2017")
    expect(page).not_to have_content("Add Date Completed")
    expect(page).not_to have_content("11/08/2018")
  end
end
