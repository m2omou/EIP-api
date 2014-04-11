class PublicationsController < ApplicationController
  before_filter :restrict_access

  # GET /publications
  # GET /publications.json
  
 
  
  def index
    
    if (params.has_key?(:user_id))
      @publications = Publication.where(user_id: params[:user_id])
    elsif (params.has_key?(:place_id))
      @publications = Publication.where(place_id: params[:place_id])
    else
      @publications = Publication.all
    end
    
    
    
    @data = {:responseCode => 0, :responseMessage => "success", :result => {:publications => @publications.as_json}}
    respond_to do |format|
        format.html
        #format.json { render json: @data , :except=>  [:file]}
        format.json { render :json => @data }
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
      format.html
      format.json { render json: @data, :except=>  [:file]}
    end
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit
  end

  # POST /publications
  # POST /publications.json
  def create
     publication_params[:file] = publication_params[:file]
     
    @publication = Publication.new(publication_params)    
   
    respond_to do |format|
      if @publication.save
        if (@publication.file_url == nil)
          @publication[:url] = publication_params[:link]
        else
          @publication[:url] = @publication.file_url
        end
        @publication.save     
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:publications => @publication}}
        format.html { redirect_to @publication, notice: 'Publication was successfully created.' }
        format.json { render json: @data, :except=>  [:file] }
      else
        @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @publication.errors}}
        format.html { render action: 'new' }
        format.json { render json: @data }
      end
    end
  end

  # PATCH/PUT /publications/1
  # PATCH/PUT /publications/1.json
  def update
    publication_params[:file] = publication_params[:file]
    
    respond_to do |format|
      if @publication.update(publication_params)
        if (@publication.file_url == nil)
          @publication[:url] = publication_params[:link]
        else
          @publication[:url] = @publication.file_url
        end
        @publication.save 
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:publications => @publication}}
        format.html { redirect_to @publication, notice: 'Publication was successfully updated.' }
        format.json { head :no_content , :except=>  [:file]}
      else
         @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @publication.errors}}
        format.html { render action: 'edit' }
        format.json { render json: @data }
      end
    end
  end

  # DELETE /publications/1
  # DELETE /publications/1.json
  def destroy
    @publication.destroy
    @data = {:responseCode => 0, :responseMessage => "success", :result => {:publication => "Entry deleted"}}
    respond_to do |format|
      format.html { redirect_to publications_url }
      format.json { render json: @data }
    end
  end

  private
  
  def restrict_access
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        User.exists?(auth_token: token, id: params[:user_id])
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
