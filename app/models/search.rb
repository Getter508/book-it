class Search
  class InvalidSearchError < StandardError; end

  attr_reader :query

  MIN_LENGTH = 3

  def self.run(query)
    new(query).call
  end

  def initialize(query)
    @query = query
  end

  def call
    if query[:search].length <= MIN_LENGTH
      raise InvalidSearchError
    else
      search_results
    end
  end

  def search_results
    if query[:category] == 'Title'
      results = Book.where('books.title ILIKE ?', "%#{query[:search]}%").order('books.title asc')
    else
      results = Book.includes(:authors).where('authors.name ILIKE ?', "%#{query[:search]}%").references(:authors).order('authors.name asc, books.title asc')
    end
    results
  end
end
