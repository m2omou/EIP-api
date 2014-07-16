module Wrapsquare
  class Place
    require 'json'

    def initialize(place, user_id, user_pos)
      @place = place
      @user_id = user_id
      @user_pos = user_pos
      @publish = @user_pos.nil? ? nil : PublicationsHelper::allowedToPublish?({:lon => @user_pos[:lon], :lat => @user_pos[:lat]},
                                                                              {:lon => self.longitude, :lat => self.latitude}, 50)
    end

    def id
      @place["id"]
    end

    def longitude
      @place["location"]["lng"]
    end

    def latitude
      @place["location"]["lat"]
    end

    def name
      @place["name"]
    end

    def postcode
      @place["location"]["postalCode"]
    end

    def city
      @place["location"]["city"]
    end

    def address
      @place["location"]["address"]
    end

    def country
      @place["location"]["country"]
    end

    def followed_place_id
      @followed_place = FollowedPlace.where(:place_id => @place["id"], :user_id => @user_id).first()
      @followed_place.nil? ? nil : @followed_place.id
    end

    # return the icon url if exist or return the default icon
    def icon
      if (@place["categories"][0] != nil)
        @place["categories"][0]["icon"]["prefix"] + "64" + @place["categories"][0]["icon"]["suffix"]
      else
        "https://ss1.4sqi.net/img/categories_v2/building/default_64.png"
      end
    end

    def distance
      @publish.nil? ? nil : @publish[:distance]
    end

    def distance_boundary
      @publish.nil? ? nil : @publish[:distance_boundary]
    end

    def can_publish
      @publish.nil? ? false : @user_id.nil? ? false : @publish[:can_publish]
    end

    # Serialize object into json
    def to_json(*a)
      {
          :id => self.id,
          :followed_place_id => self.followed_place_id,
          :longitude => self.longitude,
          :latitude => self.latitude,
          :name => self.name,
          :postcode => self.postcode,
          :city => self.city,
          :address => self.address,
          :country => self.country,
          :icon => self.icon,
          :distance => self.distance,
          :distance_boundary => self.distance_boundary,
          :can_publish => self.can_publish
      }.to_json(*a)
    end

  end

end