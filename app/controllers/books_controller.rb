class BooksController < ApplicationController
  def index
    @genre_select_options = Genre.select_options

    if sort_params.present?
      @books = Book.order_by(sort_params).includes(:authors, :genres)&.page params[:page]
    elsif filter_params.present?
      @books = Book.filter(filter_params).includes(:authors, :genres)&.page params[:page]
      @selected_genre = filter_params
    else
      @books = Book.order(Arel.sql('random()')).includes(:authors, :genres).page params[:page]
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end

  def filter_params
    params.dig(:genre, :id)
  end
end
