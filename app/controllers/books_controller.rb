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
      binding.pry
      # need to address nil case
      used_ids = cookies[:books].split("&").map { |id| id.to_i }
      @books = Book.where.not(id: used_ids.any?).order_by(sort_params, Book).includes(:authors, :genres, :have_read_books, :to_read_books)&.page params[:page]
      #need to incorporate page number and nils
      # add if else to pull from positions if not nil or grab more books if nil?
      used_ids += @books.pluck(:id)
      cookies[:books] = used_ids
      binding.pry
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
