class BooksController < ApplicationController
  def index
    @genre_select_options = Genre.select_options
    if sort_params.present?
      @books = Book.order_by(sort_params)&.page params[:page]
    elsif filter_params.present?
      @books = Book.filter(filter_params)&.page params[:page]
      @selected_genre = filter_params.nil?
    else
      @books = Book.order(Arel.sql('random()')).page params[:page]
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


# sortable_name = self.params[:sort].sub(/^(the|a|an)\s+/i, '')
