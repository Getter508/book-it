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
    {genres: genres, cover: cover, isbns: isbns}
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

    id ? "http://covers.openlibrary.org/b/id/#{id}-L.jpg" : "No cover available"
  end

  def isbns
    isbns = []
    isbns_with_dashes = @search_hash["docs"].first["isbn"]
    isbns_with_dashes.each do |isbn|
      isbn.each_char { |char| char.delete('-') }
      isbns << isbn if Isbn::LENGTHS.include?(isbn.length)
    end
    isbns
  end
end





# class OpenLibrary
#   attr_reader :isbn
#
#   def initialize(isbn)
#     @isbn = isbn
#   end
#
#   def call
#     data_call
#     search_call
#     detail_call(isbns)
#     {
#       title: title,
#       authors: authors,
#       subtitle: subtitle,
#       year: year,
#       genres: genres,
#       cover: cover,
#       isbns: isbns,
#       pages: pages,
#       description: description
#     }
#   end
#
#   def data_call
#     domain = "http://openlibrary.org/api/books?"
#     uri = URI("#{domain}bibkeys=ISBN:#{isbn}&jscmd=data&format=json")
#     response = Net::HTTP.get(uri)
#     @data_hash = JSON.parse(response)
#   end
#
#   def data_info
#     @data_info ||= @data_hash["ISBN:#{isbn}"]
#   end
#
#   def title
#     data_info["title"]
#   end
#
#   def authors
#     authors = []
#     data_info["authors"].each { |author| authors << author["name"] }
#     authors
#   end
#
#   def pages
#     data_info["number_of_pages"]
#   end
#
#   def search_call
#     uri_title = title.gsub(' ', '+')
#     uri_authors = authors.join('+')
#     domain = "http://openlibrary.org/search.json?"
#     uri = URI("#{domain}title=#{uri_title}&author=#{uri_authors}")
#     response = Net::HTTP.get(uri)
#     @search_hash = JSON.parse(response)
#   end
#
#   def search_info
#     @search_info ||= @search_hash["docs"]
#   end
#
#   def subtitle
#     search_info.find { |book| !book["subtitle"].nil? }["subtitle"]
#   end
#
#   def year
#     search_info.first["publish_year"].min
#   end
#
#   def genres
#     @genres = []
#     search_info.first["subject"].each do |genre|
#       @genres << genre.capitalize if Genre::GENRES.include?(genre.capitalize)
#       @genres << Genre::GENRES_MAP[genre.capitalize]
#     end
#     @genres.flatten.compact.uniq
#   end
#
#   def cover
#     id = search_info.find do |book|
#       !book["cover_i"].nil? && book["cover_i"] != -1
#     end["cover_i"]
#
#     id ? "http://covers.openlibrary.org/b/id/#{id}-L.jpg" : "No cover available"
#   end
#
#   def isbns
#     isbns = []
#     isbns_with_dashes = search_info.first["isbn"]
#     isbns_with_dashes.each do |isbn|
#       isbn.each_char { |char| char.delete('-') }
#       isbns << isbn if Isbn::LENGTHS.include?(isbn.length)
#     end
#     isbns
#   end
#
#   def detail_call(isbns)
#     @descriptions = []
#     isbns.each do |isbn|
#       domain = "http://openlibrary.org/api/books?"
#       uri = URI("#{domain}bibkeys=ISBN:#{isbn}&jscmd=detail&format=json")
#       response = Net::HTTP.get(uri)
#       detail_hash = JSON.parse(response)
#       detail_info = detail_hash["ISBN:#{isbn}"]["details"]
#       binding.pry
#       if detail_info
#         @descriptions << detail_info["description"]
#       end
#     end
#   end
#
#   def description
#     @descriptions.compact.sort_by! { |desc| desc.length }.last
#   end
# end







# def genres
#   @genres = []
#   book_info["subjects"].each do |genre|
#     @genres << genre["name"].capitalize if Genre::GENRES.include?(genre["name"].capitalize)
#     @genres << Genre::GENRES_MAP[genre["name"].capitalize]
#   end
#   @genres.flatten.compact.uniq
# end
#
# def cover
#   if book_info.dig("cover", "large")
#     book_info["cover"]["large"]
#   elsif book_info.dig("cover", "medium")
#     book_info["cover"]["medium"]
#   elsif book_info.dig("cover", "small")
#     book_info["cover"]["small"]
#   else
#     "No cover available"
#   end
# end





# def cover
#   ids = []
#   search_info.each do |book|
#     ids << book["cover_i"] if !book["cover_i"].nil? && book["cover_i"] != -1
#   end
#
#   if ids
#     id = ids.sort.last
#     "http://covers.openlibrary.org/b/id/#{id}-L.jpg"
#   else
#     "No cover available"
#   end
# end
