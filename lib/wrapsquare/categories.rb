module Wrapsquare
  class Categories

    def initialize(foursquare)
      @fq = foursquare
    end

    # show categories
    def show()
      @categories = @fq.get("categories")
      # check if foursquare is alive
=begin
      if @categories["venues"].nil?
        return []
      end
=end

      puts @categories

      return @categories

      # map the venues into objets
=begin
      @places = []
      @places += @venues["venues"].map do |item|
        Wrapsquare::Place.new(item, @user_id, @user_pos)
      end
      return @places
=end
    end
  end

end