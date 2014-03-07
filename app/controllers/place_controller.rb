require 'foursquare'
require 'json'
class PlaceController < ApplicationController
	def index
		# if !signed_in?
		# 	render :partial => 'welcome/home'
		# elsif (params.has_key?(:id))
		## TODO: Check if you are well connected ... Because currently everyone can access :/
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
