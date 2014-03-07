class PlaceController < ApplicationController
	def index
		@test = params[:id]
		@place = Place.find(params[:id])
	end
end
