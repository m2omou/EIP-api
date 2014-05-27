class PublicationsController < ApplicationController
  before_filter :restrict_access, only: [:create, :destroy, :update]

  # GET /publications
  # GET /publications.json

  def index
    @count = params.has_key?(:count) ? params[:count] : 20
    @since_id = params.has_key?(:since_id) ? params[:since_id] : 0
    @max_id = params.has_key?(:max_id) ? params[:max_id] : -1

    @query = "id >= #{@since_id}"
    if (@max_id != -1)
      @query += " AND id <= #{@max_id}"
    end
    respond_to do |format|
        if (params.has_key?(:place_id))
          @publications = Publication.where(place_id: params[:place_id])
                                     .where(@query)
                                     .limit(@count)
          @data = {:responseCode => 0, :responseMessage => "success", :result => {:publications => @publications}}
        else
          @data = [:responseCode => 1, :responseMessage => "error",
                   :result => {:error => "Parameter place_id is needed"}]
        end
        format.html
        format.json { render :json => @data.as_json(:params => request.protocol + request.host_with_port,
                                                    :auth_user_id => get_auth_token_user_id()) }
      end
  end

  # GET /publications/1
  # GET /publications/1.json
  def show
     begin
      @publication = Publication.find(params[:id])
      @data = {:responseCode => 0, :responseMessage => "success", :result => {:publication => @publication.as_json}}
    rescue ActiveRecord::RecordNotFound => e
      @data = {:responseCode => 1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end
    respond_to do |format|
      format.html { render "publication"}
      format.json { render json: @data, :except=>  [:file]}
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

    respond_to do |format|
      if @publication.save
        @publication = PublicationsHelper.checkPublicationType(@publication, publication_params)
        @publication.save
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:publication => @publication}}
        format.html { redirect_to "/places/" + publication_params[:place_id], notice: 'Publication was successfully created.' }
        format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port), :except=> [:file] }
      else
        @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @publication.errors}}
        format.html { render action: 'new' }
        format.json { render json: @data }
      end
    end

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
    unless  session[:user_id]
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
