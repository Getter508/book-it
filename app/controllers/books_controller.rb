class BooksController < ApplicationController
  helper_method :sort_attribute, :sort_direction

  def index
    @books = Book.order(sort_attribute + " " + sort_direction).limit(10)
  end

  def show
    @book = Book.find(params[:id])
  end

  private

  def sort_attribute
    %w[title author].include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
