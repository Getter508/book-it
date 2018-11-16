class HaveReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    user_book_ids = current_user.have_read_books.order(date_completed: :desc).pluck(:book_id)

    @have_read_books = user_book_ids.map do |id|
      Book.where(id: id).includes(:authors)
    end.flatten

    if sort_params.present?
      @have_read_books = Book.where(id: user_book_ids).order_by(sort_params)
    end
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
