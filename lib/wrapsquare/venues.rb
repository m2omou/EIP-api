module Wrapsquare
  class Venues

    def initialize(foursquare, user_id)
      @fq = foursquare
      @user_id = user_id
    end

    # find a specific venue
    def find(id)
      @venue = @fq.get("#{id}/?", {})["venue"]
      return Wrapsquare::Place.new(@venue, @user_id)
    end

    # search venues by latitude & longitude
    def search(lat, lon, radius = 800, limit = 10)
      @venues = @fq.get("search?", {:ll => "#{lat},#{lon}", :intent => "browse", :limit => limit, :radius => radius})
      # check if foursquare is alive
      if @venues["venues"].nil?
        return []
      end
      # map the venues into objets
      @places = []
      @places += @venues["venues"].map do |item|
        Wrapsquare::Place.new(item, @user_id)
      end
      return @places
    end
  end

end