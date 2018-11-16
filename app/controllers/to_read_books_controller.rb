class ToReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    user_book_ids = current_user.to_read_books.order(rank: :asc).pluck(:book_id)

    @to_read_books = user_book_ids.map do |id|
      Book.where(id: id).includes(:authors)
    end.flatten

    if sort_params.present?
      @to_read_books = Book.where(id: user_book_ids).order_by(sort_params).includes(:authors)
    end
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
