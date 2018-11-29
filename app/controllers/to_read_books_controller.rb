class ToReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @to_read_books = current_user.to_complete_books.order_by(sort_params, ToReadBook).includes(:authors, :genres)&.page params[:page]
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
