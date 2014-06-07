module Wrapsquare
  class Place
    require 'json'

    def initialize(place, user_id)
      @place = place
      @user_id = user_id
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
          :icon => self.icon
      }.to_json(*a)
    end

  end

end