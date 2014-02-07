class FoursquaresController < ApplicationController
  before_action :set_foursquare, only: [:show, :edit, :update, :destroy]

  # GET /foursquares
  # GET /foursquares.json
  
  require 'open-uri'
  
  def index
    
    if (params.has_key?(:latitude) && params.has_key?(:longitude))
      @latitude = params[:latitude]
      @longitude = params[:longitude]
      
      @url = "https://api.foursquare.com/v2/venues/search?ll=" + @latitude + "," + @longitude + "&oauth_token=KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG&v=20131129"
      
      begin
        @venues = JSON.parse(open(@url).read)
        @venues = @venues["response"]["venues"]
        
        #@venues = @venues[0]["categories"][0]["id"]
        
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
        
        
      rescue => e
        @places = "some failure: #{e}"
      end      

      respond_to do |format|
        format.html
        format.json { render json: @places }
      end  
     
    end
  end


  # GET /foursquares/1
  # GET /foursquares/1.json
  def show
  end

  # GET /foursquares/new
  def new
    @foursquare = Foursquare.new
  end

  # GET /foursquares/1/edit
  def edit
  end

  # POST /foursquares
  # POST /foursquares.json
  def create
    @foursquare = Foursquare.new(foursquare_params)

    respond_to do |format|
      if @foursquare.save
        format.html { redirect_to @foursquare, notice: 'Foursquare was successfully created.' }
        format.json { render action: 'show', status: :created, location: @foursquare }
      else
        format.html { render action: 'new' }
        format.json { render json: @foursquare.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foursquares/1
  # PATCH/PUT /foursquares/1.json
  def update
    respond_to do |format|
      if @foursquare.update(foursquare_params)
        format.html { redirect_to @foursquare, notice: 'Foursquare was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @foursquare.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foursquares/1
  # DELETE /foursquares/1.json
  def destroy
    @foursquare.destroy
    respond_to do |format|
      format.html { redirect_to foursquares_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_foursquare
      @foursquare = Foursquare.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def foursquare_params
      params[:foursquare]
    end
end
