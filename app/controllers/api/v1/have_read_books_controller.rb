class Api::V1::HaveReadBooksController < ApplicationController
  def create
    have_read_book = HaveReadBook.new(ajax_params)
    have_read_book.user = current_user
    have_read_book.build_date(date_params)

    if have_read_book.save
      to_read_book = ToReadBook.find_by(user: current_user, book_id: ajax_params[:book_id])
      current_user.update_ranks(book_id: ajax_params[:book_id], old_rank: to_read_book&.rank, new_rank: nil)
      to_read_book&.destroy

      to_read_books = current_user.to_read_books.where.not(rank: nil).map do |trb|
        { trb_id: trb.book_id, trb_rank: trb.rank }
      end

      render json: {
        book_id: "#{ajax_params[:book_id]}",
        to_read_books: to_read_books,
        status: :created
      }
    else
      render json: :nothing, status: :not_found
    end
  end

  def update
    have_read_book = HaveReadBook.find(params[:id])
    have_read_book.build_date(date_params)
    have_read_book.rating = ajax_params[:rating]
    have_read_book.note = ajax_params[:note]

    if have_read_book.save
      render json: {
        book_id: ajax_params[:book_id],
        rating: ajax_params[:rating],
        date: have_read_book.display_date_completed,
        status: :created
      }
    else
      render json: :nothing, status: :not_found
    end
  end

  private

  def ajax_params
    params.permit(:book_id, :rating, :note)
  end

  def date_params
    [params.require(:month), params.require(:day), params.require(:year)]
  end
end
