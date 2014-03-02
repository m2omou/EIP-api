class PlaceController < ApplicationController

	def index
		@test = params[:id]
	end
end
