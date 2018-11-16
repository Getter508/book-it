class HaveReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    user_book_ids = current_user.have_read_books.order(date_completed: :desc).pluck(:book_id)
    @have_read_books = Book.where(id: user_book_ids).includes(:authors)
    @have_read_books = @have_read_books.order_by(sort_params) if sort_params.present?
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
