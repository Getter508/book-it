class BookImporterService
  attr_reader :isbns

  def self.call(isbns:)
    new(isbns: isbns).call
  end

  def initialize(isbns:)
    @isbns = isbns
  end

  def call
    sleep 2
    errors = []
    isbns.each do |isbn|
      begin
        google_book_info = GoogleBook.new.call(isbn)
        open_library_info = OpenLibrary.new(isbn).call
        book_data = google_book_info.merge(open_library_info)
        book = create_book(book_data)
        author = create_author(book_data, book.id)
        genre = create_genre(book_data, book.id)
        isbn_obj = create_isbn(book_data, book.id)
      rescue StandardError => e
        errors << [isbn]
      end
    end
    puts "ERRORS: #{errors.join(', ')}"
  end

  def create_book(data)
    book = Book.find_or_create_by(
      title: data[:title],
      subtitle: data[:subtitle],
      year: data[:year],
      pages: data[:pages],
      description: data[:description],
      cover: data[:cover]
    )
    @books << book
    book
  end

  def create_author(data, book_id)
    data[:authors].each do |name|
      author = Author.find_or_create_by(name: name)
      authors << author
      create_book_author(author, book_id)
    end
    authors
  end

  def create_book_author(author, book_id)
    BookAuthor.find_or_create_by(author_id: author.id, book_id: book_id)
  end

  def create_genre(data, book_id)
    data[:genres].each do |name|
      genre = Genre.find_or_create_by(name: name)
      genres << genre
      create_book_genre(genre, book_id)
    end
    genres
  end

  def create_book_genre(genre, book_id)
    BookGenre.find_or_create_by(genre_id: genre.id, book_id: book_id)
  end

  def create_isbn(data, book_id)
    data[:isbns].each do |id|
      isbn = Isbn.find_or_create_by(international_standard_book_number: id, book_id: book_id)
      isbns << isbn
    end
    isbns
  end
end



# class BookImporterService
#   attr_reader :isbns
#
#   def self.call(isbns:)
#     new(isbns: isbns).call
#   end
#
#   def initialize(isbns:)
#     @isbns = isbns
#   end
#
#   def call
#     @books = []
#     @authors = []
#     @genres = []
#     isbns.each do |isbn|
#       book_data = OpenLibrary.new(isbn).call
#       book = create_book(book_data)
#       author = create_author(book_data, book.id)
#       genre = create_genre(book_data, book.id)
#     end
#   end
#
#   def create_book(data)
#     # binding.pry
#     book = Book.find_or_create_by(
#       title: data[:title],
#       subtitle: data[:subtitle],
#       year: data[:year],
#       pages: data[:pages],
#       description: data[:description],
#       cover: data[:cover]
#     )
#     @books << book
#     book
#   end
#
#   def create_author(data, book_id)
#     data[:authors].each do |name|
#       author = Author.find_or_create_by(name: name)
#       @authors << author
#       # binding.pry
#       book_author = BookAuthor.find_or_create_by(book_id: book_id, author_id: author.id)
#     end
#   end
#
#   def create_genre(data, book_id)
#     data[:genres].each do |name|
#       genre = Genre.find_or_create_by(name: name)
#       @genres << genre
#       # binding.pry
#       book_genre = BookGenre.find_or_create_by(book_id: book_id, genre_id: genre.id)
#     end
#   end
# end
