class BookImporterService
  class GoogleBook
    def call(isbn)
      key = ENV['GOOGLE_API_KEY']
      domain = 'https://www.googleapis.com/books/v1/volumes?'
      uri = URI("#{domain}q=isbn:#{isbn}&key=#{key}")
      response = Net::HTTP.get(uri)
      @book_hash = JSON.parse(response)
      {
        title: title,
        subtitle: subtitle,
        year: year,
        pages: pages,
        description: description,
        authors: authors
      }
    end

    def book_info
      @book_info ||= @book_hash['items'][0]['volumeInfo']
    end

    def title
      book_info['title']
    end

    def subtitle
      book_info['subtitle']
    end

    def year
      book_info['publishedDate'].scan(/\b\d{4}\b/).first.to_i
    end

    def pages
      book_info['pageCount']
    end

    def description
      book_info['description']
    end

    def authors
      authors = []
      book_info['authors'].each { |author| authors << author }
    end
  end
end
