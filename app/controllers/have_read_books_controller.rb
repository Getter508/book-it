class HaveReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_month = Time.zone.now.strftime("%b")
    @current_day = Time.zone.now.day
    @current_year = Time.zone.now.year
    @have_read_books = current_user.completed_books.order_by(sort_params, HaveReadBook).includes(:authors, :genres, :have_read_books)&.page params[:page]
  end

  def update
    @have_read_book = HaveReadBook.find_by(user: current_user, book_id: params[:id])
    @have_read_book.build_date(have_read_params)

    if @have_read_book.date_completed.nil?
      redirect_to have_read_books_path, alert: "Invalid date"
    elsif @have_read_book.save
      redirect_to have_read_books_path, notice: "Date completed successfully updated"
    else
      redirect_to have_read_books_path, alert: "Date failed to update"
    end
  end

  private

  def have_read_params
    [params.require(:month), params.require(:day), params.require(:year)]
  end

  def sort_params
    params.permit(:sort, :direction)
  end
end
