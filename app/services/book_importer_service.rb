class BookImporterService
  attr_reader :isbns

  def self.call(isbns:)
    new(isbns: isbns).call
  end

  def initialize(isbns:)
    @isbns = isbns
  end

  def call
    errors = {}
    isbns.each do |isbn|
      begin
        google_book_info = GoogleBook.new.call(isbn)
        open_library_info = OpenLibrary.new(isbn).call
        book_data = google_book_info.merge(open_library_info)
        book = create_book(book_data)
        author = create_author(book_data, book.id)
        genre = create_genre(book_data, book.id)
        isbn_obj = create_isbn(book_data, book.id, isbn)
      rescue StandardError => e
        errors[isbn] = "#{e.class}: #{e.full_messages}"
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
    book
  end

  def create_author(data, book_id)
    data[:authors].each do |name|
      author = Author.where(name: data[:alt_author_names]).first
      if author.nil?
        author = Author.find_or_create_by(name: name)
      end
      create_book_author(author, book_id)
    end
  end

  def create_book_author(author, book_id)
    BookAuthor.find_or_create_by(author_id: author.id, book_id: book_id)
  end

  def create_genre(data, book_id)
    unless data[:genres].blank?
      data[:genres].each do |name|
        genre = Genre.find_or_create_by(name: name)
        create_book_genre(genre, book_id)
      end
    end
  end

  def create_book_genre(genre, book_id)
    BookGenre.find_or_create_by(genre_id: genre.id, book_id: book_id)
  end

  def create_isbn(data, book_id, primary_isbn)
    data[:isbns].each do |international_standard_book_number|
      isbn = Isbn.find_or_create_by(international_standard_book_number: international_standard_book_number, book_id: book_id)
      if isbn.international_standard_book_number == primary_isbn
        isbn.primary_number = true
        isbn.save
      end
    end
  end
end
