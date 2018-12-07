class Api::V1::HaveReadBooksController < ApplicationController
  def create
    have_read_book = HaveReadBook.new(ajax_params)
    have_read_book.user = current_user
    have_read_book.build_date(date_params)

    if have_read_book.save
      render json: {book_id: "#{ajax_params[:book_id]}", status: :created}
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
