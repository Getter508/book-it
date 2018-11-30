class ToReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @to_read_books = current_user.to_complete_books.order_by(sort_params, ToReadBook).includes(:authors, :genres)&.page params[:page]
  end

  def create
    to_read_book = ToReadBook.new(user: current_user, book_id: create_params)
    if to_read_book.save
      redirect_to books_path, notice: "Book successfully added To Read"
    else
      redirect_to books_path, alert: "Adding To Read failed"
    end
  end

  def update
    if current_user.update_ranks(params[:id], to_read_params[:rank])
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

  def create_params
    params.require(:book_id)
  end
end
