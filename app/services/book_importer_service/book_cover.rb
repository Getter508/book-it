class BookImporterService
  class BookCover
    attr_reader :width, :height, :size

    MAX_HEIGHT = 450
    MAX_WIDTH = 300

    def self.create(id)
      cover = new(id)
      @size = cover.image_size
      cover.set_width_and_height
      cover
    end

    def initialize(id)
      @id = id
      @ratio = nil
    end

    def set_width_and_height
      @width = @size&.first
      @height = @size&.last
    end

    def image_size
      n = 0
      @size = nil
      until (@size.present? || n == 5)
        @size = FastImage.size(url)
        n += 1
      end
      @size
    end

    def url
      "http://covers.openlibrary.org/b/id/#{@id}-L.jpg"
    end

    def ratio
      @ratio ||= set_ratio
    end

    def set_ratio
      if @width.nil? || @height.nil? || @width.zero?
        0
      else
        @height.to_f / @width.to_f
      end
    end

    def qualifies?
      return false if @height.blank? || @width.blank?
      min_height = 0.8 * MAX_HEIGHT
      min_width = 0.8 * MAX_WIDTH

      @height >= min_height && @width >= min_width && ratio <= 1.65 && ratio >= 1.4
    end
  end
end
