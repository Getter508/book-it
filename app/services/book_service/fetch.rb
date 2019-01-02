class BookService
  class Fetch
    def self.call(sort_params:, cookie:, page:)
      new(sort_params, cookie, page).call
    end

    def initialize(sort_params, cookie, page)
      @sort_params = sort_params
      @cookie = cookie
      @page = page
    end

    def call
      fetch_used_ids
      @first_index = (page - 1) * 30
      @indices_in_question = @used_ids.slice(@first_index, 30)

      if new_page_visited
        @books = Book.where.not(id: @used_ids.any?).order_by(@sort_params, Book).includes(:authors, :genres, :have_read_books, :to_read_books)&.page(page)
        add_book_ids
      else
        @books = Book.where(id: @indices_in_question)
      end

      @updated_cookie = @used_ids
      self
    end

    def books
      @books
    end

    def updated_cookie
      @updated_cookie
    end

    def fetch_used_ids
      if @cookie.nil?
        @used_ids = []
      else
        @used_ids = @cookie.split("&").map { |id| id.to_i }
      end
    end

    def new_page_visited
      @first_index >= @used_ids.length || @indices_in_question.includes?(0) #might need to be nil
    end

    def add_book_ids
      if @first_index >= @used_ids.length
        number_of_nils = (page * 30) - @used_ids.length
        number_of_nils.times { @used_ids << nil }
        @used_ids += @books.pluck(:id)
      else
        i = 0
        @indices_in_question.each do |index|
          @used_ids[index] = @books[i].id
          i += 1
        end
      end
    end
  end
end


# if (page * 30) == @cookie.length
#   @used_ids += @books.pluck(:id)
# else
#   number_of_nils = (page * 30) - @cookie.length
#   number_of_nils.times { @used_ids << nil }
#   @used_ids += @books.pluck(:id)
# end
