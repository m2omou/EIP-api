# This class contains some method using the foursquare API.
class Foursquare
	class << self

    API = "https://api.foursquare.com/v2/venues/"
    OAUTH_TOKEN = "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG"
    VERSION = "20131129"

		# This method returns the data of a place using its ID with the Foursquare API.
    def find_followed_place_id(place_id, user_id)
      @followed_place = FollowedPlace.where(:place_id => place_id, :user_id => user_id).first()
      if (@followed_place)
        return @followed_place.id
      end
      return nil
    end

    # keep !
    #def find_followed_place_id(place_id, user_id)
    #  @followed_place = FollowedPlace.where(:place_id => place_id, :user_id => user_id).first()
    #  @followed_place.nil? ? @followed_place.id : nil
    #end

		def find_place(id, user_id)

			url = API + id + "/?oauth_token=KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG&v=20131129"

      		begin
      			venue = JSON.parse(open(url).read)
      			venue = venue["response"]["venue"]

      			if (venue["categories"][0] != nil)
      				icon = venue["categories"][0]["icon"]["prefix"] + "64" + venue["categories"][0]["icon"]["suffix"]
      			else
      				icon = "https://ss1.4sqi.net/img/categories_v2/building/default_64.png"
      			end

      			place =
      			{
      				:id => venue["id"],
              :test => 42,
      				:longitude => venue["location"]["lng"],
      				:latitude => venue["location"]["lat"],
      				:name => venue["name"],
      				:postcode => venue["location"]["postalCode"],
      				:city => venue["location"]["city"],
      				:address => venue["location"]["address"],
      				:country => venue["location"]["country"],
      				:icon => icon
      			}
      			data = {:responseCode => 0, :responseMessage => "success", :result => {:place => place}}
      		rescue => e
		       	error = "ID not found"#JSON.parse(e.io.string)["meta"]["errorDetail"]
		       	data = {:responseCode => 1, :responseMessage => "error", :result => {:error => error}}
		       end
		end #find_place

		# This method returns *limit* places around the *lat* and *long* point
		# delimited by a distance of *radius* meters.
		def find_places(lat, lon, radius = 800, limit = 10, user_id)
			begin
				if (radius == nil || radius == 0)
					radius = 800
				end

				if  limit == nil || limit == 0
					limit = 10
				end

				url = API + "search?ll=" +
				lat + "," + lon +
				"&oauth_token=KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG&v=20131129&intent=browse&limit=" +
				limit + "&radius=" + radius

				venues = JSON.parse(open(url).read)

				venues = venues["response"]["venues"]

				places = venues.map do |u|
					if (u["categories"][0] != nil)
						icon = u["categories"][0]["icon"]["prefix"] + "bg_32" + u["categories"][0]["icon"]["suffix"]
					else
						icon = "https://ss1.4sqi.net/img/categories_v2/building/default_bg_32.png"
					end

					{ :id => u["id"],
            :followed_place_id => find_followed_place_id(u["id"], user_id),
						:longitude => u["location"]["lng"],
						:latitude => u["location"]["lat"],
						:name => u["name"],
						:postcode => u["location"]["postalCode"],
						:city => u["location"]["city"],
						:address => u["location"]["address"],
						:country => u["location"]["country"],
						:icon => icon
					}
				end
				data = {:responseCode => 0, :responseMessage => "success", :result => {:places => places}}
			rescue => e
				data = [:responseCode => 1, :responseMessage => "error", :result => {:error => "Bad input for latitude(double), longitude(double), radius(int), and limit(int)."}]
			end
		end


	end #class << self
end #class