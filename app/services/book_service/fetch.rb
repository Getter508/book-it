module BookService
  class Fetch
    attr_reader :books, :updated_cookie

    def self.call(cookie:, page:)
      new(cookie, page).call
    end

    def initialize(cookie, page)
      @cookie = cookie
      @page = page || 1
      @per_page = 30
    end

    def call
      Book.instance_variable_set(:@current_page, @page.to_i)

      if new_page_visited?
        @books = Book.where.not(id: used_ids).randomize.includes(:authors, :genres, :have_read_books, :to_read_books).limit(@per_page)
        add_book_ids
      else
        @books = Book.find_ordered(ids_in_question).includes(:authors, :genres, :have_read_books, :to_read_books).limit(@per_page)
      end

      @updated_cookie = used_ids
      self
    end

    def new_page_visited?
      ids_in_question&.include?(0) || first_index >= used_ids.length
    end

    def ids_in_question
      @ids_in_question ||= used_ids.slice(first_index, @per_page)
    end

    def used_ids
      @used_ids ||= fetch_used_ids
    end

    def fetch_used_ids
      if @cookie.nil? || @cookie.empty?
        @used_ids = []
      else
        @used_ids = @cookie.split('&').map(&:to_i)
      end
    end

    def first_index
      @first_index ||= (@page.to_i - 1) * @per_page
    end

    def add_book_ids
      if first_index >= used_ids.length
        number_of_zeros = first_index - used_ids.length
        number_of_zeros.times { used_ids << 0 }
        @used_ids += @books.map(&:id)
      else
        i = 0
        indices_in_question.each do |index|
          @used_ids[index] = @books[i].id
          i += 1
        end
      end
    end

    def indices_in_question
      @indices_in_question ||= determine_indices_in_question
    end

    def determine_indices_in_question
      @indices_in_question = (first_index...(first_index + @per_page)).to_a
    end
  end
end
