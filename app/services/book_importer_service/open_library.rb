class BookImporterService
  class OpenLibrary
    attr_reader :isbn

    def initialize(isbn)
      @isbn = isbn
    end

    def call
      domain = 'http://openlibrary.org/api/books?'
      uri = URI("#{domain}bibkeys=ISBN:#{isbn}&jscmd=data&format=json")
      response = Net::HTTP.get(uri)
      @book_hash = JSON.parse(response)

      return { isbns: [isbn] } if @book_hash.blank?

      begin
        search_call
        {
          genres: genres,
          cover: cover,
          isbns: isbns,
          alt_author_names: alt_author_names
        }
      rescue URI::InvalidURIError
        { isbns: [isbn] }
      end
    end

    def book_info
      @book_info ||= @book_hash["ISBN:#{isbn}"]
    end

    def title
      book_info['title']
    end

    def authors
      authors = []
      book_info['authors'].each { |author| authors << author['name'] }
      authors
    end

    def search_call
      subs = { ' ' => '+', "'" => '&#39;', '"' => '' }
      regex = "#{subs.keys.join('|')}"
      uri_title = title.gsub(Regexp.new(regex), subs)
      uri_authors = authors.join('+').gsub(Regexp.new(regex), subs)
      domain = 'http://openlibrary.org/search.json?'
      uri = URI("#{domain}title=#{uri_title}&author=#{uri_authors}")
      response = Net::HTTP.get(uri)
      @search_hash = JSON.parse(response)
    end

    def search_info
      @search_info ||= @search_hash['docs'].select do |book|
        book['title_suggest'] == title && (authors & book['author_name']).present?
      end
    end

    def genres
      @genres = []
      search_info.first['subject']&.each do |genre|
        @genres << genre.capitalize if Genre::GENRES.include?(genre.capitalize)
        @genres << Genre::GENRES_MAP[genre.capitalize]
      end
      @genres.flatten.compact.uniq
    end

    def cover
      book_covers = search_info.map do |book|
        unless book['cover_i'].nil? || book['cover_i'] == -1
          BookImporterService::BookCover.create(book['cover_i'])
        end
      end.compact

      target_covers = book_covers.map do |cover|
        cover if cover.qualifies?
      end.compact

      return nil if target_covers.empty?
      target_covers.sort_by { |cover| (cover.ratio - 1.5).abs }.first.url
    end

    def isbns
      isbns = []
      orig_isbns = search_info.map { |entry| entry['isbn'] }.flatten.compact.uniq
      orig_isbns.each do |isbn|
        without_dashes = isbn.delete('-')
        isbns << without_dashes if Isbn::LENGTHS.include?(without_dashes.length)
      end
      isbns << @isbn unless isbns.include?(@isbn)
      isbns
    end

    def alt_author_names
      search_info.first['author_alternative_name']
    end
  end
end
