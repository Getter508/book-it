class BooksController < ApplicationController
  def index
    @genre_select_options = Genre.select_options

    if search_params.present?
      @books = Search.run(search_params).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
    elsif filter_params.present?
      @books = Book.filter(genre_id: filter_params).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
      @selected_genre = filter_params
    else
      @books = Book.order_by(sort_params, Book).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
    end
  end

  def show
    @book = Book.find(params[:id])
    @to_read_book = ToReadBook.find_or_initialize_by(user: current_user, book_id: params[:id])
    @have_read_book = HaveReadBook.find_or_initialize_by(user: current_user, book_id: params[:id])
    @reviews = HaveReadBook.order_list(book_id: params[:id], user: current_user)
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end

  def filter_params
    params.dig(:genre, :id)
  end

  def search_params
    params.permit(:search, :category)
  end
end
