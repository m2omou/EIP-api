module Wrapsquare
  class Venues

    def initialize(foursquare, user_id, user_pos)
      @fq = foursquare
      @user_id = user_id
      @user_pos = user_pos
    end

    # find a specific venue
    def find(id)
      @venue = @fq.get("#{id}/?", {})["venue"]
      @venue.nil? ? nil : Wrapsquare::Place.new(@venue, @user_id, @user_pos)
    end

    # search venues by latitude & longitude
    def search(lat, lon, radius = 800, limit = 10, category_id)
      @venues = @fq.get("search?", {:ll => "#{lat},#{lon}", :intent => "browse",
                                    :limit => limit, :radius => radius, :categoryId => category_id})
      # check if foursquare is alive
      return [] if @venues["venues"].nil?
      # map the venues into objets
      @places = []
      @places += @venues["venues"].map do |item|
        Wrapsquare::Place.new(item, @user_id, @user_pos)
      end
      return @places
    end

    # search venues by name
    def search_by_name(name, limit = 10, category_id = "")
      @venues = @fq.get("search?", {:query => name, :intent => "global", :limit => limit, :categoryId => category_id})
      # check if foursquare is alive
      return [] if @venues["venues"].nil?
      # map the venues into objets
      @places = []
      @places += @venues["venues"].map do |item|
        Wrapsquare::Place.new(item, @user_id, @user_pos)
      end
      return @places
    end

  end
end