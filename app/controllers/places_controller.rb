class PlacesController < ApplicationController

  before_action :set_place, only: [:edit, :update, :destroy]

  require 'open-uri'
  require 'json'
  require 'foursquare'

  # GET /places
  # GET /places.json
  def index
   respond_to do |format|
     if (params.has_key?(:latitude) && params.has_key?(:longitude))

      limit = params.has_key?(:limit) ? params[:limit] : "10"
      radius = params.has_key?(:radius) ? params[:radius] : "800"

      latitude = params[:latitude]
      longitude = params[:longitude]

      data = Foursquare.find_places(latitude, longitude, radius, limit) 
      format.json { render json: data }
    else
      data = [:responseCode => 1, :responseMessage => "error", :result => {:error => "Parameters longitude and latitude are needed"}]
      format.json { render json: data }
      format.html { redirect_to "/"}
    end
  end  
end

  # GET /places/1
  # GET /places/1.json
  def show
    # if signed_in?
      respond_to do |format|
        if (params.has_key?(:id))
          @place = Foursquare.find_place(params[:id])
          @publications = Publication.where(place_id: @place[:result][:place][:id]).to_a.map(&:serializable_hash)
          @new_publication = Publication.new
          if (signed_in?)
            @new_publication[:user_id] = session[:user_id]
          end
          @new_publication[:place_id] = @place[:result][:place][:id]
          @new_publication[:longitude] = @place[:result][:place][:longitude]
          @new_publication[:latitude] = @place[:result][:place][:latitude]
          format.html { render "place" }
          format.json { render json: @place }
        else
          data = [:responseCode => 1, :responseMessage => "error", :result => {:error => "Please indicate the ID."}]
          format.html { redirect_to "/" }
          format.json { render json: data }
        end
      end
  end

  private
  def restrict_access
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        User.exists?(auth_token: token)
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_place
     #@place = Place.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def place_params
     params[:place]
  end
end
