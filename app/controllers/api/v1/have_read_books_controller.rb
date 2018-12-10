class Api::V1::HaveReadBooksController < ApplicationController
  def create
    have_read_book = HaveReadBook.new(ajax_params)
    have_read_book.user = current_user
    have_read_book.build_date(date_params)

    if have_read_book.save
      to_read_book = ToReadBook.find_by(user: current_user, book_id: ajax_params[:book_id])
      current_user.update_ranks(ajax_params[:book_id], to_read_book.rank, nil)
      to_read_book&.destroy
      trb_books = current_user.to_read_books.where.not(rank: nil).map { |trb| {trb_book_id: trb.book_id, rank: trb.rank} }

      render json: {
        book_id: "#{ajax_params[:book_id]}",
        trb_books: trb_books,
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