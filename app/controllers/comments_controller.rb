class CommentsController < ApplicationController
  before_filter :restrict_access, except: [:show, :index]
  
  # GET /comments
  # GET /comments.json
  def index
    @count = params.has_key?(:count) ? (params[:count].to_i > 200 ? 200 : params[:count]) : 20
    @since_id = params.has_key?(:since_id) ? params[:since_id] : 0
    @max_id = params.has_key?(:max_id) ? params[:max_id] : -1

    @query = "id > #{@since_id}"
    if (@max_id != -1)
      @query += " AND id < #{@max_id}"
    end

    @comments = Comment.all
    if (params.has_key?(:publication_id))
      @comments = Comment.where(publication_id: params[:publication_id])
                         .where(@query)
                         .limit(@count)
                         .order("id DESC")
      @data = {:responseCode => 0, :responseMessage => "success", :result => {:comments => @comments}}
    else
      @data = {:responseCode => 1, :responseMessage => "error", :result => "Please send the parameter publication_id" }
    end

    respond_to do |format|
        format.html
        format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port) }
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
        format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port) }
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
    begin
      @comment = Comment.find(params[:id])

      if (@comment.user_id == get_auth_token_user_id())
        @comment.destroy
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:comment => "comment deleted"}}
      else
        @data = {:responseCode => -1, :responseMessage => "Must be the owner", :result => nil}
      end
    rescue ActiveRecord::RecordNotFound => e
      @data = {:responseCode => -1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end
    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { render json: @data }
    end
  end

  private

  # ask for token access
  def restrict_access
    if  session[:user_id]
      comment_params[:user_id] = session[:user_id]
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !comment_params.nil?
            comment_params[:user_id] = @user.id
          end
          return true
        end
        false
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
