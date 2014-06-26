class PlacesController < ApplicationController
  before_action :set_place, only: [:edit, :update, :destroy]

  require 'open-uri'
  require 'json'
  require "wrapsquare/base"
  require "wrapsquare/place"
  require "wrapsquare/venues"

  # GET /places
  # GET /places.json
  def index
   respond_to do |format|
     if (params.has_key?(:latitude) && params.has_key?(:longitude))
      limit = params.has_key?(:limit) ? params[:limit] : "10"
      radius = params.has_key?(:radius) ? params[:radius] : "800"
      latitude = params[:latitude]
      longitude = params[:longitude]
      user_lat = params.has_key?(:user_latitude) ? params[:user_latitude] : nil
      user_long = params.has_key?(:user_longitude) ? params[:user_longitude] : nil

      # set the foursquare token and version
      @foursquare = Wrapsquare::Base.new(:oauth_token  => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                         :version      => "20131129",
                                         :user_id => get_auth_token_user_id(),
                                         :user_pos => user_lat.nil? || user_long.nil? ? nil : {:lat => user_lat, :lon => user_long})
      # get the foursquare's venues
      @places = @foursquare.venues.search(latitude, longitude, radius, limit)
      @data = ApplicationHelper.jsonResponseFormat(0, "success", {:places => @places.map { |p| JSON.parse(p.to_json) }})
      format.json { render json: @data }
     else
      data = ApplicationHelper.jsonResponseFormat(1, "error", :result => {:error => "Parameters longitude and latitude are needed"})
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
          # set the foursquare token and version
          @foursquare = Wrapsquare::Base.new(:oauth_token => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                             :version     => "20131129", :user_id => get_auth_token_user_id())
          # get the foursquare's venues
          @place = @foursquare.venues.find(params[:id])
          @publications = Publication.where(place_id: @place.id).to_a.map(&:serializable_hash)
          @new_publication = Publication.new
          if (signed_in?)
            @new_publication[:user_id] = session[:user_id]
          end
          @new_publication[:place_id] = @place.id
          @new_publication[:user_longitude] = @place.longitude
          @new_publication[:user_latitude] = @place.latitude
          format.html { render "place" }
          format.json { render json: ApplicationHelper.jsonResponseFormat(0, "success",
                                                                          {:place => JSON.parse(@place.to_json())})}
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
