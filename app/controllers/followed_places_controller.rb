class FollowedPlacesController < ApplicationController
  before_filter :restrict_access

  # GET /followed_places
  # GET /followed_places.json
  def index
    @auth_user_id = get_auth_token_user_id()

    @user_id = @auth_user_id == -1 ? params[:user_id] : @auth_user_id
    @count = params.has_key?(:count) ? params[:count] : 20
    @since_id = params.has_key?(:since_id) ? params[:since_id] : 0
    @max_id = params.has_key?(:max_id) ? params[:max_id] : -1

    @query = "id > #{@since_id}"
    if (@max_id != -1)
      @query += " AND id < #{@max_id}"
    end
    respond_to do |format|
      @followed_places = FollowedPlace.where(user_id: @user_id)
                                      .where(@query)
                                      .order("id DESC")
                                      .limit(@count)
      @data = {:responseCode => 0, :responseMessage => "success", :result => {:places => @followed_places}}
      format.html
      format.json { render :json => @data.as_json(:opt => "index") }
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
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !followed_place_params.nil?
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
