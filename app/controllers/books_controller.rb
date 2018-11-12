class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    binding.pry
    @book = Book.find(params[:id])
  end
end
