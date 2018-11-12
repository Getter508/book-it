class OpenLibrary
  attr_reader :isbn

  def initialize(isbn)
    @isbn = isbn
  end

  def call
    domain = "http://openlibrary.org/api/books?"
    uri = URI("#{domain}bibkeys=ISBN:#{isbn}&jscmd=data&format=json")
    response = Net::HTTP.get(uri)
    @book_hash = JSON.parse(response)
    sleep 2
    search_call
    {
      genres: genres,
      cover: cover,
      isbns: isbns,
      alt_author_names: alt_author_names
    }
  end

  def book_info
    @book_info ||= @book_hash["ISBN:#{isbn}"]
  end

  def title
    book_info["title"]
  end

  def authors
    authors = []
    book_info["authors"].each { |author| authors << author["name"] }
    authors
  end

  def search_call
    uri_title = title.gsub(' ', '+')
    uri_authors = authors.join('+')
    domain = "http://openlibrary.org/search.json?"
    uri = URI("#{domain}title=#{uri_title}&author=#{uri_authors}")
    response = Net::HTTP.get(uri)
    @search_hash = JSON.parse(response)
  end

  def search_info
    @search_info ||= @search_hash["docs"]
  end

  def genres
    @genres = []
    search_info.first["subject"]&.each do |genre|
      @genres << genre.capitalize if Genre::GENRES.include?(genre.capitalize)
      @genres << Genre::GENRES_MAP[genre.capitalize]
    end
    @genres.flatten.compact.uniq
  end

  def cover
    id = search_info.find do |book|
      !book["cover_i"].nil? && book["cover_i"] != -1
    end&.dig("cover_i")

    if id.present?
      "http://covers.openlibrary.org/b/id/#{id}-L.jpg"
    end
  end

  def isbns
    isbns = []
    orig_isbns = search_info.first["isbn"]
    orig_isbns.each do |isbn|
      without_dashes = isbn.delete('-')
      isbns << without_dashes if Isbn::LENGTHS.include?(without_dashes.length)
    end
    isbns << @isbn unless isbns.include?(@isbn)
    isbns
  end

  def alt_author_names
    search_info.first["author_alternative_name"]
  end
end
