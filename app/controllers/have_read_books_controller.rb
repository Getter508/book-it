class HaveReadBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @have_read_books = current_user.completed_books.order_by(sort_params, HaveReadBook).includes(:authors, :genres, :have_read_books)&.page params[:page]
  end

  def create
    book = Book.find(have_read_params[:book_id])
    have_read_book = HaveReadBook.new(have_read_params)
    have_read_book.user = current_user
    have_read_book.build_date(date_params) unless params[:month].nil?

    if have_read_book.save
      to_read_book = ToReadBook.find_by(user: current_user, book_id: have_read_params[:book_id])
      current_user.update_ranks(book_id: have_read_params[:book_id], old_rank: to_read_book&.rank, new_rank: nil)
      to_read_book&.destroy

      redirect_to book_path(book), notice: 'Book successfully added to Have Read'
    else
      redirect_to book_path(book), alert: 'Book failed to save to Have Read'
    end
  end

  def update
    @book = Book.find(have_read_params[:book_id])
    @have_read_book = HaveReadBook.find_by(user: current_user, book_id: have_read_params[:book_id])
    @have_read_book.assign_attributes(have_read_params)

    if @have_read_book.save
      redirect_to book_path(@book), notice: 'Have Read book successfully updated'
    else
      params[:condition] = 'edit'
      @reviews = HaveReadBook.order_list(book_id: params[:id], user: current_user)
      flash[:alert] = 'Have Read book failed to update'
      render 'books/show'
    end
  end

  def create_or_update
    have_read_book = HaveReadBook.exists?(user: current_user, book_id: have_read_params[:book_id])
    have_read_book.present? ? update : create
  end

  def update_date
    @have_read_book = HaveReadBook.find(have_read_params[:id])
    @have_read_book.build_date(date_params)

    if @have_read_book.date_completed.nil?
      redirect_to have_read_books_path, alert: 'Invalid date'
    elsif @have_read_book.save
      redirect_to have_read_books_path, notice: 'Date completed successfully updated'
    else
      redirect_to have_read_books_path, alert: 'Date completed failed to update'
    end
  end

  def destroy
    have_read_book = HaveReadBook.find(params[:id])
    have_read_book.destroy
    redirect_to have_read_books_path, notice: 'Book removed from your Have Read list'
  end

  def destroy_review
    @have_read_book = HaveReadBook.find(params[:id])
    @have_read_book.rating = nil
    @have_read_book.note = nil
    @have_read_book.save

    @book = @have_read_book.book
    @reviews = HaveReadBook.order_list(book_id: params[:id], user: current_user)
    params[:condition] = 'deleted'
    flash[:notice] = 'Your review has been deleted'
    render 'books/show'
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
