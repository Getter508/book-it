class InvalidSearchError < StandardError; end

class Search
  attr_accessor :query

  MIN_LENGTH = 3

  def self.run(query)
    new(query).call
  end

  def initialize(query)
    @query = query
  end

  def call
    if query.length <= MIN_LENGTH
      raise InvalidSearchError
    else
      Book.includes(:authors).where('books.title ILIKE ? OR authors.name ILIKE ?', "%#{query}%", "%#{query}%").references(:authors)
    end
  end
end
