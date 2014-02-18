class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  
  require 'open-uri'
  require 'json'
  
  def index
     respond_to do |format|
     if (params.has_key?(:latitude) && params.has_key?(:longitude))
        
        if params.has_key?(:limit)
          @limit = params[:limit]
        else
          @limit = "10"
        end
        
        if params.has_key?(:radius)
          @radius = params[:radius]
        else
          @radius = "800"
        end
       
        @latitude = params[:latitude]
        @longitude = params[:longitude]
        
        @url = "https://api.foursquare.com/v2/venues/search?ll=" + 
               @latitude + "," + @longitude + 
               "&oauth_token=KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG&v=20131129&intent=browse&limit=" + 
               @limit + "&radius=" + @radius
        
        begin
          @venues = JSON.parse(open(@url).read)
          @venues = @venues["response"]["venues"]
          @places = @venues.map do |u|
            
            if (u["categories"][0] != nil)
              @icon = u["categories"][0]["icon"]["prefix"] + "64" + u["categories"][0]["icon"]["suffix"]
            else
              @icon = "https://ss1.4sqi.net/img/categories_v2/building/default_64.png"
            end
            
            { :id => u["id"], 
              :longitude => u["location"]["lng"], 
              :latitude => u["location"]["lat"],
              :name => u["name"],
              :postcode => u["location"]["postalCode"],
              :city => u["location"]["city"],
              :address => u["location"]["address"],
              :country => u["location"]["country"],
              :icon => @icon
            }
          end
          @data = {:responseCode => 0, :responseMessage => "success", :result => {:places => @places}}
          format.json { render json: @data }
        rescue => e
          @error = "Parameters longitude & latitude are needed"#JSON.parse(e.io.string)["meta"]["errorDetail"]
          @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @error}}
          format.json { render json: @data }
        end      
          
      else
        @data = [:responseCode => 1, :responseMessage => "error", :result => {:error => "Parameters longitude & latitude are needed"}]
        format.json { render json: @data }
      end
    end  
  end

  # GET /places/1
  # GET /places/1.json
  def show
    respond_to do |format|
    if (params.has_key?(:id))
      @id = params[:id]
      
      @url = "https://api.foursquare.com/v2/venues/" + @id + "/?oauth_token=KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG&v=20131129"
      
      #open("https://api.foursquare.com/v2/venues/asdasd/?oauth_token=KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG&v=20131129")
      
      begin
        @venue = JSON.parse(open(@url).read)
        
        
           @venue = @venue["response"]["venue"]
   
          if (@venue["categories"][0] != nil)
            @icon = @venue["categories"][0]["icon"]["prefix"] + "64" + @venue["categories"][0]["icon"]["suffix"]
          else
             @icon = "https://ss1.4sqi.net/img/categories_v2/building/default_64.png"
          end
          
          @place = 
          { 
            :id => @venue["id"], 
            :longitude => @venue["location"]["lng"], 
            :latitude => @venue["location"]["lat"],
            :name => @venue["name"],
            :postcode => @venue["location"]["postalCode"],
            :city => @venue["location"]["city"],
            :address => @venue["location"]["address"],
            :country => @venue["location"]["country"],
            :icon => @icon
          } 
          @data = {:responseCode => 0, :responseMessage => "success", :result => {:place => @place}}
      rescue => e
        @error = "ID not found"#JSON.parse(e.io.string)["meta"]["errorDetail"]
        @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @error}}
      end      
      
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
