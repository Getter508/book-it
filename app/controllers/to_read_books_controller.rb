class ToReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    # binding.pry
    user_book_ids = current_user.to_read_books.order(rank: :asc).pluck(:book_id)
    @to_read_books = Book.where(id: user_book_ids).includes(:authors)
    @to_read_books = @to_read_books.order_by(sort_params) if sort_params.present?
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
