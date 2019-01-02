class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @genre_select_options = Genre.select_options

    if search_params.present?
      @search = true
      @books = Search.run(search_params).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
    elsif filter_params.present?
      @books = Book.filter(genre_id: filter_params).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
      @selected_genre = filter_params
    else
      # ken
      book_fetch_service = BookService::Fetch.call(
        sort_params: sort_params,
        cookie: cookies[:books],
        page: params[:page]
      )
      @books = book_fetch_service.books
      cookies[:books] = book_fetch_service.updated_cookie
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
