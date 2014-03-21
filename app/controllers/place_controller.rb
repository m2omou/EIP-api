require 'foursquare'
require 'json'

# This class manages the view /place/:id. This view loads a place
# and allows the user to see the last post and to publish new data.
class PlaceController < ApplicationController

# This method is launch when the user comes to the page. It check if he is well
# authenticate and then load the indicate place using the :id.
	def index
		if (current_user != nil)
			@place = Place.find_or_initialize_by(id_foursquare: params[:id])
			if (@place.new_record? == true)
				fs_place = JSON.parse(Foursquare.find_place(params[:id]).to_json)["result"]["place"]
				@place.longitude = fs_place["longitude"]
				@place.latitude = fs_place["latitude"]
				@place.name = fs_place["name"]
				@place.postcode = fs_place["postcode"]
				@place.city = fs_place["city"]
				@place.address = fs_place["address"]
				@place.country = fs_place["country"]
				@place.created_at = Date.current
				@place.updated_at = Date.current
				@place.save
			end
		else
		    redirect_to root_url
		end
			
			# begin
	  # 			@place = Place.find_by(id_foursquare: params[:id])
			# rescue ActiveRecord::RecordNotFound
			# 	foursquarePlace = 
			# 	Place.new(:id_foursquare: params[:id], )
			# 	@place 
	  		# end		
	  	# end
	end
end
