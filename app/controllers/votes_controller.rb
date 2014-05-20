class VotesController < ApplicationController
  before_action :set_vote, only: [:show, :edit, :update, :destroy]
  before_filter :restrict_access
  # GET /votes
  # GET /votes.json
  def index
   
    if (params.has_key?(:publication_id))
      @votes = Vote.where(publication_id: params[:publication_id])
      @data = {:responseCode => 0, :responseMessage => "success", :result => {:votes => @votes}}
    else
      @data = {:responseCode => 1, :responseMessage => "error", :result => "Please send the parameters publication_id" }
    end

    respond_to do |format|
        format.html
        format.json { render json: @data }
      end  
    
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
  end

  # GET /votes/new
  def new
    @vote = Vote.new
  end

  # GET /votes/1/edit
  def edit
  end

  # POST /votes
  # POST /votes.json
  def create
     respond_to do |format|

       # get the user_id from the token, but for the web still get it from the params
       if (vote_params.has_key?(:user_id))
          @user_id = vote_params[:user_id]
       end

     if (@user_id == -1)
        @data = {:responseCode => 1, :responseMessage => "error", :result => "Bad token" }
         format.html { render action: 'new' }
         format.json {  render json: @data }
     else
         if (vote_params.has_key?(:publication_id))
           if (Vote.exists?(:publication_id => vote_params[:publication_id]))
               Vote.where(:publication_id => vote_params[:publication_id], :user_id => @user_id).destroy_all
           end
         end
       vote_params[:user_id] = @user_id
       @vote = Vote.new(vote_params)
       @vote.save
       @data = {:responseCode => 0, :responseMessage => "success", :result => {:vote => @vote.as_json}}

      if (params.has_key?(:redirect)) 
        format.html { redirect_to params[:redirect], notice: 'Vote was successfully created.' }
      else
        format.html { redirect_to @vote, notice: 'Vote was successfully created.' }
      end
       format.json {  render json: @data }
     end
    end
  end

  # PATCH/PUT /votes/1
  # PATCH/PUT /votes/1.json
  def update
    respond_to do |format|
      if @vote.update(vote_params)
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote.destroy
    @data = {:responseCode => 0, :responseMessage => "success", :result => {:vote => @vote.as_json}}
    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { render json: @data }
    end
  end

  private
  def restrict_access
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        if ((@value = User.exists?(auth_token: token)))
          @user = User.find_by_auth_token(token)
          @user_id = @user.id
          return @value
        else
          @user_id = -1
          return @value
        end
      end
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params[:vote]
    end
end
