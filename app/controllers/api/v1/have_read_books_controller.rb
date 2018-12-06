class Api::V1::HaveReadBooksController < ApplicationController
  def create
    binding.pry
  end

  private

  def ajax_params
    params.permit(:book_id, :month, :day, :year, :rating, :note)
  end
end
