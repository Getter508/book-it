class BooksController < ApplicationController
  def index
    if sort_params.present?
      @books = Book.order_by(sort_params).limit(10)
    else
      @books = Book.all.limit(10)
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end

# sortable_name = self.params[:sort].sub(/^(the|a|an)\s+/i, '')
