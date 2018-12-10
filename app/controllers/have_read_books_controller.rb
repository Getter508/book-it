class HaveReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @have_read_books = current_user.completed_books.order_by(sort_params, HaveReadBook).includes(:authors, :genres, :have_read_books)&.page params[:page]
  end

  def create
    book = Book.find(have_read_params[:book_id])
    have_read_book = HaveReadBook.new(user: current_user, book_id: have_read_params[:book_id])

    if have_read_book.save
      redirect_to book_path(book), notice: "Book successfully added to Have Read"
    else
      redirect_to book_path(book), alert: "Book failed to save to Have Read"
    end
  end

  def update
    @book = Book.find(have_read_params[:book_id])
    @have_read_book = HaveReadBook.find_by(user: current_user, book_id: have_read_params[:book_id])
    @have_read_book.build_date(date_params)
    @have_read_book.assign_attributes(have_read_params)

    if @have_read_book.save
      redirect_to book_path(@book), notice: "Have Read book successfully updated"
    else
      redirect_to book_path(@book), alert: "Have Read book failed to update"
    end
  end

  def create_or_update
    have_read_book = HaveReadBook.find_by(user: current_user, book_id: have_read_params[:book_id])
    have_read_book.nil? ? create : update
  end

  def update_date
    @have_read_book = HaveReadBook.find(have_read_params[:id])
    @have_read_book.build_date(date_params)

    if @have_read_book.date_completed.nil?
      redirect_to have_read_books_path, alert: "Invalid date"
    elsif @have_read_book.save
      redirect_to have_read_books_path, notice: "Date completed successfully updated"
    else
      redirect_to have_read_books_path, alert: "Date completed failed to update"
    end
  end

  private

  def date_params
    [params.require(:month), params.require(:day), params.require(:year)]
  end

  def sort_params
    params.permit(:sort, :direction)
  end

  def have_read_params
    params.permit(:id, :book_id, :rating, :note)
  end
end
