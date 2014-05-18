class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_filter :restrict_access
  
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
    
    if (params.has_key?(:publication_id))
      @votes = Vote.where(publication_id: params[:publication_id])
      @data = {:responseCode => 0, :responseMessage => "success", :result => {:comments => @comments}}  
    else
      @data = {:responseCode => 1, :responseMessage => "error", :result => "Please send the parameters publication_id" }
    end
    
    
    respond_to do |format|
        format.html
        format.json { render json: @data }
      end  
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:comment => @comment}}
        url = "/publications/" + comment_params[:publication_id]
        format.html { redirect_to url, notice: 'Comment was successfully created.' }
        format.json { render json: @data }
      else
        @data = {:responseCode => 1, :responseMessage => "error", :result => @comment.errors }

        url = "/publications/" + comment_params[:publication_id]
        format.html { redirect_to url, notice: 'An error occured and the comment has not been created.' }
        format.json { render json: @data }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:comment => @comment}}
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render json: @data }
      else
        @data = {:responseCode => 1, :responseMessage => "error", :result => @comment.errors }
        format.html { render action: 'edit' }
        format.json { render json: @data }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      @data = {:responseCode => 0, :responseMessage => "success", :result => {:comment => "comment deleted"}}
      format.html { redirect_to comments_url }
      format.json { render json: @data }
    end
  end

  private
  
   def restrict_access
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        User.exists?(auth_token: token)
      end
    end
  end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
       params[:comment]
    end
end
