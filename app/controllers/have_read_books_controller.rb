class HaveReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    if sort_params.present?
      @have_read_books = current_user.completed_books.order_by(sort_params).includes(:authors, :genres)
    else
      @have_read_books = current_user.completed_books.order("have_read_books.date_completed desc").includes(:authors, :genres)
    end
  end

  private

  def sort_params
    params.permit(:sort, :direction)
  end
end
