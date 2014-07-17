class FollowedPlacesController < ApplicationController
  before_filter :restrict_access, :except => [:index]

  require "wrapsquare/base"
  require "wrapsquare/place"
  require "wrapsquare/venues"

  # GET /followed_places
  # GET /followed_places.json
  def index
    respond_to do |format|
      if (params.has_key?(:since_id) && params.has_key?(:max_id))
        format.json { render :json => ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "Please select either since_id or max_id"}) }
      else
        @auth_user_id = get_auth_token_user_id()
        @user_id = @auth_user_id.nil? ? params[:user_id] : @auth_user_id
        @count = params.has_key?(:count) ? ApplicationHelper.checkEmptyValue(params[:count]) : 20
        @since_id = params.has_key?(:since_id) ? ApplicationHelper.checkEmptyValue(params[:since_id]) : 0
        @max_id = params.has_key?(:max_id) ? ApplicationHelper.checkEmptyValue(params[:max_id]) : -1
        @user_lat = params.has_key?(:user_latitude) ? params[:user_latitude] : nil
        @user_long = params.has_key?(:user_longitude) ? params[:user_longitude] : nil
        @order = "DESC"

        if (params.has_key?(:since_id))
          @query = "id > #{@since_id}"
          @order = "ASC"
        elsif (params.has_key?(:max_id))
          @query = "id < #{@max_id}"
        else
          @query = nil
        end

        # set the foursquare token and version
        @foursquare = Wrapsquare::Base.new(:oauth_token  => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                           :version      => "20131129",
                                           :user_id => get_auth_token_user_id(),
                                           :user_pos => @user_lat.nil? || @user_long.nil? ? nil : {:lat => @user_lat, :lon => @user_long})
        @followed_places = FollowedPlace.where(user_id: @user_id).where(@query).order("id " + @order).limit(@count)
        @followed_places = @order == "ASC" ? @followed_places.reverse : @followed_places
        @data = ApplicationHelper.jsonResponseFormat(0, "success", {:places => @followed_places})
        format.html
        format.json { render :json => @data.as_json(:opt => "index", :fq => @foursquare) }
      end
    end
  end

  # GET /followed_places/1
  # GET /followed_places/1.json
  def show
  end

  # GET /followed_places/new
  def new
    @followed_place = FollowedPlace.new
  end

  # GET /followed_places/1/edit
  def edit
  end

  # POST /followed_places
  # POST /followed_places.json
  def create
    @followed_place = FollowedPlace.new(followed_place_params)

    # To avoid doublons
    FollowedPlace.where(:place_id => followed_place_params[:place_id],
                        :user_id => followed_place_params[:user_id]).destroy_all

    respond_to do |format|
      if @followed_place.save

        @data = {:responseCode => 0, :responseMessage => "success", :result => {:place => @followed_place}}

        format.html { redirect_to @followed_place, notice: 'Followed place was successfully created.' }
        format.json { render json: @data.as_json() }
      else
        @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @followed_place.errors}}
        format.html { render action: 'new' }
        format.json { render json: @data }
      end
    end
  end

  # PATCH/PUT /followed_places/1
  # PATCH/PUT /followed_places/1.json
  def update
    respond_to do |format|
      if @followed_place.update(followed_place_params)
        format.html { redirect_to @followed_place, notice: 'Followed place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @followed_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /followed_places/1
  # DELETE /followed_places/1.json
  def destroy
    begin
      @followed_place = FollowedPlace.find(params[:id])

      if (@followed_place.user_id == get_auth_token_user_id())
        @followed_place.destroy
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:publication => "Entry deleted"}}
      else
        @data = {:responseCode => -1, :responseMessage => "Must be the owner", :result => nil}
      end
    rescue ActiveRecord::RecordNotFound => e
      @data = {:responseCode => -1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end
    respond_to do |format|
      format.html { redirect_to followed_places_url }
      format.json { render json: @data }
    end
  end

  private

  # ask for token access
  def restrict_access
    puts "TOKEN ACCESS DEBUG"
    if  session[:user_id]
      puts "has session"
      if !followed_place_params.nil?
        puts "params not nul"
        followed_place_params[:user_id] = session[:user_id]
      end
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        puts "GET user_id from token"
        if (@user)
          if !followed_place_params.nil?
            puts "user_id = #{@user.id}"
            followed_place_params[:user_id] = @user.id
          end
          return true
        end
        false
      end
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_followed_place
      @followed_place = FollowedPlace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def followed_place_params
      params[:followed_place]
    end
end
