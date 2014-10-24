class VotesController < ApplicationController
  before_action :set_vote, only: [:show, :edit, :update]
  before_filter :restrict_access, only: [:create, :destroy, :update]

  # GET /votes
  # GET /votes.json
  def index
    # for the back office
    if (current_user.role == BackOfficeRoles::ADMIN)
      @votes =  Vote.all()
      return render :html => @votes
    end

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

  def update
    # for the back office
    if (current_user.role == BackOfficeRoles::ADMIN)
      @vote = Vote.find(params[:id])
      @vote.update_attributes(params[:vote])
      redirect_to @vote
    end
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(vote_params)

    # for the back office
    if (current_user.role == BackOfficeRoles::ADMIN)
      respond_to do |format|
        if @vote.save
          format.html { redirect_to @vote, :notice => 'Vote was successfully created.' }
        else
          format.html { render :action => "new" }
        end
      end
      return
    end


    respond_to do |format|
      if (Publication.exists?(:id => vote_params[:publication_id]))
          Vote.where(:publication_id => vote_params[:publication_id], :user_id => vote_params[:user_id]).destroy_all
          if @vote.save
              @like = @vote.publication ? @vote.publication.votes.where(:value =>  true).count : 0
              @dislike = @vote.publication ? @vote.publication.votes.where(:value =>  false).count : 0

              @data = {:responseCode => 0, :responseMessage => "success",
                        :result => {:vote => @vote, :publication => {:upvotes => @like, :downvotes => @dislike }}}

              format.json {  render json: @data }
          else
            @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @vote.errors}}
          end
      else
        @data = {:responseCode => 1, :responseMessage => "publication_id doesn't exist", :result => {:error => @vote.errors}}
      end

      format.json { render json: @data }
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    if (current_user.role == BackOfficeRoles::ADMIN)
      @vote = Vote.find(params[:id])
      @vote.destroy
    end

    begin
      @vote = Vote.find(params[:id])
      if (@vote.user_id == get_auth_token_user_id())
        @vote.destroy

        @like = @vote.publication ? @vote.publication.votes.where(:value =>  true).count : 0
        @dislike = @vote.publication ? @vote.publication.votes.where(:value =>  false).count : 0

        @data = {:responseCode => 0, :responseMessage => "success", :result => {
                         :publication => {:upvotes => @like, :downvotes => @dislike}}}
      else
        @data = {:responseCode => -1, :responseMessage => "Must be the owner", :result => nil}
      end
    rescue ActiveRecord::RecordNotFound => e
      @data = {:responseCode => 1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end
    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { render json: @data }
    end
  end

  private
  def restrict_access
    if  session[:user_id]
      if !vote_params.nil?
        vote_params[:user_id] = session[:user_id]
      end
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(auth_token: token).first()
        if (@user)
          if !vote_params.nil?
            vote_params[:user_id] = @user.id
          end
          return true
        end
        false
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
