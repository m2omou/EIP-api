class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  
  require 'open-uri'
  require 'json'
  require 'foursquare'
  
  def index
     respond_to do |format|
     if (params.has_key?(:latitude) && params.has_key?(:longitude))
        
        if params.has_key?(:limit)
          limit = params[:limit]
        else
          limit = "10"
        end
        
        if params.has_key?(:radius)
          radius = params[:radius]
        else
          radius = "800"
        end
       
        latitude = params[:latitude]
        longitude = params[:longitude]

        data = Foursquare.find_places(latitude, longitude, radius, limit) 
        format.json { render json: data }
      else
        data = [:responseCode => 1, :responseMessage => "error", :result => {:error => "Parameters longitude anda latitude are needed"}]
        format.json { render json: data }
      end
    end  
  end

  # GET /places/1
  # GET /places/1.json
  def show
    respond_to do |format|
    if (params.has_key?(:id))
      Foursquare.find_place(params[:id])
    end
        format.html
        format.json { render json: @data }
    end
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      #@place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params[:place]
    end
end
