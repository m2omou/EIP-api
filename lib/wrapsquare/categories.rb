module Wrapsquare
  class Categories

    def initialize(foursquare)
      @fq = foursquare
    end

    # show categories
    def show()
      @categories = @fq.get("categories")
      # map the categories into objets
      @result = []
      @result += @categories["categories"].map do |item|
        Wrapsquare::Category.new(item)
      end
      return @result
    end
  end

end