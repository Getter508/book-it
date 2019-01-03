module BookService
  class Fetch
    def self.call(sort_params:, cookie:, page:)
      new(sort_params, cookie, page).call
    end

    def initialize(sort_params, cookie, page)
      @sort_params = sort_params
      @cookie = cookie
      @page = page || 1
    end

    def call
      fetch_used_ids
      @first_index = (@page.to_i - 1) * 30
      last_index = @first_index + 29
      @indices_in_question = (@first_index..last_index).to_a
      @ids_in_question = @used_ids.slice(@first_index, 30)

      if new_page_visited
        @books = Book.where.not(id: @used_ids).order_by(@sort_params, Book).includes(:authors, :genres, :have_read_books, :to_read_books)&.page(@page.to_i)
        add_book_ids
      else
        @books = Book.find_ordered(@ids_in_question).includes(:authors, :genres, :have_read_books, :to_read_books)&.page(@page.to_i)
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
      if @cookie.nil? || @cookie.empty?
        @used_ids = []
      else
        @used_ids = @cookie.split("&").map { |id| id.to_i }
      end
    end

    def new_page_visited
      @ids_in_question&.include?(0) || @first_index >= @used_ids.length
    end

    def add_book_ids
      if @first_index >= @used_ids.length
        number_of_zeros = @first_index - @used_ids.length
        number_of_zeros.times { @used_ids << 0 }
        @used_ids += @books.map(&:id)
      else
        i = 0
        @indices_in_question.each do |index|
          @used_ids[index] = @books[i].id #test failing here because only 2 books created for test!
          i += 1
        end
      end
    end
  end
end
