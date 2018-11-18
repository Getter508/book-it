class ToReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    if sort_params.present?
      @to_read_books = current_user.to_complete_books.order_by(sort_params).includes(:authors, :genres)
    else
      @to_read_books = current_user.to_complete_books.order("to_read_books.rank asc").includes(:authors, :genres)
    end
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
