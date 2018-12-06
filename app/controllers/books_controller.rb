class BooksController < ApplicationController
  def index
    @genre_select_options = Genre.select_options

    if filter_params.present?
      @books = Book.filter(filter_params).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
      @selected_genre = filter_params
    else
      @books = Book.order_by(sort_params, Book).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
    end
  end

  def show
    @book = Book.find(params[:id])
    @to_read_book = ToReadBook.find_or_initialize_by(user: current_user, book_id: params[:id])
    @have_read_book = HaveReadBook.find_or_initialize_by(user: current_user, book_id: params[:id])
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end

  def filter_params
    params.dig(:genre, :id)
  end
end
