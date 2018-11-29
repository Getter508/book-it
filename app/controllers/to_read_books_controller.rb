class ToReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @to_read_books = current_user.to_complete_books.order_by(sort_params, ToReadBook).includes(:authors, :genres)&.page params[:page]
  end

  def update
    @to_read_book = ToReadBook.find_by(user: current_user, book_id: params[:id])
    @to_read_book.update_attributes(to_read_params)

    if @to_read_book.save
      redirect_to to_read_books_path, notice: "Rank successfully saved"
    else
      redirect_to to_read_books_path, alert: "Rank failed to update"
    end
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end

  def to_read_params
    params.permit(:rank)
  end
end
