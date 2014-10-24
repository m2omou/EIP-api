class PublicationsController < ApplicationController
  before_filter :restrict_access, only: [:create, :destroy, :update]

  require "wrapsquare/base"
  require "wrapsquare/place"
  require "wrapsquare/venues"

  # GET /publications
  # GET /publications.json

  def index
    # for the back office
    if (current_user.role == BackOfficeRoles::ADMIN)
      @publications =  Publication.all()
      return render :html => @publications
    end

    if (params.has_key?(:since_id) && params.has_key?(:max_id))
      render :json => ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "Please select either since_id or max_id"})
    else
      @count = params.has_key?(:count) ? ApplicationHelper.checkEmptyValue(params[:count]) : 20
      @since_id = params.has_key?(:since_id) ? ApplicationHelper.checkEmptyValue(params[:since_id]) : 0
      @max_id = params.has_key?(:max_id) ? ApplicationHelper.checkEmptyValue(params[:max_id]) : -1
      @order = "DESC"

      if (params.has_key?(:since_id))
        @query = "id > #{@since_id}"
        @order = "ASC"
      elsif (params.has_key?(:max_id))
        @query = "id < #{@max_id}"
      else
        @query = nil
      end

      if (!params.has_key?(:place_id) && !params.has_key?(:user_id))
        @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "Place_id or/and user_id are needed"})
      else
        @opt = {}
        @opt.merge!(:place_id => params[:place_id]) if params.has_key?(:place_id)
        @opt.merge!(:user_id => params[:user_id]) if params.has_key?(:user_id)

        @publications = Publication.where(@opt).where(@query).order("id " + @order).limit(@count)
        @publications = @order == "ASC" ? @publications.reverse : @publications
        @data = ApplicationHelper.jsonResponseFormat(0, "success", {:publications => @publications})
      end

      # set the foursquare token and version
      @foursquare = Wrapsquare::Base.new(:oauth_token  => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                         :version      => "20131129", :user_id => get_auth_token_user_id())

      render :json => @data.as_json(:params => request.protocol + request.host_with_port,
                                    :auth_user_id => get_auth_token_user_id(), :fq => @foursquare)
    end
  end


  # SHOW /publications/id.json

  def show
    begin
      @publication = Publication.find(params[:id])
      @data = ApplicationHelper.jsonResponseFormat(0, "success", {:publication => @publication})
      # set the foursquare token and version
      @foursquare = Wrapsquare::Base.new(:oauth_token  => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                         :version      => "20131129", :user_id => get_auth_token_user_id())

      respond_to do |format|
        format.html { @publication }
        format.json { render :json => @data.as_json(:params => request.protocol + request.host_with_port,
                                                      :auth_user_id => get_auth_token_user_id(),
                                                      :fq => @foursquare) }
      end

    rescue ActiveRecord::RecordNotFound => e
      render :json => ApplicationHelper.jsonResponseFormat(-1, "Record not found", {:error => e.message})
    end
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # POST /publications
  # POST /publications.json
  def create
    @publication = Publication.new(publication_params)

    # for the back office
    if (current_user.role == BackOfficeRoles::ADMIN)
      respond_to do |format|
        if @publication.save
          format.html { redirect_to @publication, :notice => 'Like was successfully created.' }
        else
          format.html { render :action => "new" }
        end
      end
      return
    end

    # User position
    @user_lat = publication_params[:user_latitude]
    @user_lon = publication_params[:user_longitude]

    # set the foursquare token and version
    @foursquare = Wrapsquare::Base.new(:oauth_token => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                       :version     => "20131129", :user_id => get_auth_token_user_id())
    # get the foursquare's venues
    @place = @foursquare.venues.find(@publication.place_id)
    if (@place.nil?)
      return render json: ApplicationHelper.jsonResponseFormat(1, "Place_id doesn't exist", nil)
    end

    # If the user is too far from the place, the user won't be able to create a publication
    # Check the distance between the place and the user, the distance must be under 50 meters
    @canPublish = PublicationsHelper.allowedToPublish?({:lon => @user_lon, :lat => @user_lat},
                                                       {:lon => @place.longitude, :lat => @place.latitude}, 50)

    if (@canPublish[:can_publish])
      if @publication.save
        @publication = PublicationsHelper.checkPublicationType(@publication, publication_params)
        @publication.save
        @data = @data = ApplicationHelper.jsonResponseFormat(0, "success", {:publication => @publication})
        render json: @data.as_json(:params => request.protocol + request.host_with_port), :except=> [:file]
      else
        render json: ApplicationHelper.jsonResponseFormat(1, "Error", {:error => @publication.errors})
      end
    else
      render json: ApplicationHelper.jsonResponseFormat(1, "Il semblerait que vous soyez trop loin de ce lieu pour pouvoir poster... Rapprochez vous !", {:error => nil})
    end

  end

  def update
    # for the back office
    if (current_user.role == BackOfficeRoles::ADMIN)
      @publication = Publication.find(params[:id])
      @publication.update_attributes(params[:publication])
      redirect_to @publication
    end

  end

  def edit
    @publication = Publication.find(params[:id])
  end

  # DELETE /publications/1
  # DELETE /publications/1.json
  def destroy
    begin
      @publication = Publication.find(params[:id])

      if (@publication.user_id == get_auth_token_user_id())
        @publication.destroy
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:publication => "Entry deleted"}}
      else
        @data = {:responseCode => -1, :responseMessage => "Must be the owner", :result => nil}
      end
    rescue ActiveRecord::RecordNotFound => e
      @data = {:responseCode => -1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end
    respond_to do |format|
      format.html { redirect_to publications_url }
      format.json { render json: @data }
    end
  end

  private

  # ask for token access
  def restrict_access
    if  session[:user_id]
      if !publication_params.nil?
        publication_params[:user_id] = session[:user_id]
      end
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !publication_params.nil?
            publication_params[:user_id] = @user.id
          end
          return true
        end
        false
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_publication
    @publication = Publication.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def publication_params
    params[:publication]
  end
end
