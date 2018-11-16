class HaveReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    user_book_ids = HaveReadBook.where(user: current_user).order(date_completed: :desc).pluck(:book_id)

    if sort_params.present?
      @have_read_books = Book.where(id: user_book_ids).order_by(sort_params)
    else
      @have_read_books = Book.where(id: user_book_ids)
    end
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
