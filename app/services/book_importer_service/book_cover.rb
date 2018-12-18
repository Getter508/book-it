class BookImporterService
  class BookCover
    attr_accessor :width, :height

    MAX_HEIGHT = 450
    MAX_WIDTH = 300

    def self.create(id)
      cover = new(id)
      size = cover.image_size
      cover.width = size.first
      cover.height = size.last
      cover
    end

    def initialize(id)
      @id = id
    end

    def image_size
      FastImage.size("http://covers.openlibrary.org/b/id/#{@id}-L.jpg")
    end

    def ratio
      @ratio ||= height.to_f / width.to_f
    end

    def qualifies?
      min_height = 0.85 * MAX_HEIGHT
      min_width = 0.85 * MAX_WIDTH

      height >= min_height && width >= min_width && ratio <= 1.6 && ratio >= 1.4
    end
  end
end
