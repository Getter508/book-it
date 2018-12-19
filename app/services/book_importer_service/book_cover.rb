class BookImporterService
  class BookCover
    attr_accessor :width, :height

    MAX_HEIGHT = 450
    MAX_WIDTH = 300

    def self.create(id)
      cover = new(id)
      size = cover.image_size
      cover.width = size&.first
      cover.height = size&.last
      cover
    end

    def initialize(id)
      @id = id
      @ratio = nil
    end

    def image_size
      n = 0
      size = nil
      until (size.present? || n == 5)
        size = FastImage.size("http://covers.openlibrary.org/b/id/#{@id}-L.jpg")
        n += 1
      end
      size
    end

    def ratio
      @ratio ||= set_ratio
    end

    def set_ratio
      if width.nil? || height.nil? || width.zero?
        0
      else
        height.to_f / width.to_f
      end
    end

    def qualifies?
      min_height = 0.85 * MAX_HEIGHT
      min_width = 0.85 * MAX_WIDTH

      height >= min_height && width >= min_width && ratio <= 1.6 && ratio >= 1.4
    end
  end
end
