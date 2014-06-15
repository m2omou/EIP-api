class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]
  before_filter :restrict_access

  # GET /conversations
  # GET /conversations.json
  # Get the list of conversations for the authenticated user
  def index
    respond_to do |format|
      # GET parameters
      @count = params.has_key?(:count) ? ApplicationHelper.checkEmptyValue(params[:count]) : 20
      @count = @count.to_i > 200 ? 200 : @count
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

      @conversations = Conversation.where(@query).order("id " + @order).limit(@count)
      @conversations = @order == "ASC" ? @conversations.reverse : @conversations
      @data = ApplicationHelper.jsonResponseFormat(0, "success", {:conversations => @conversations})
      format.json { render json: @data.as_json(:opt => "index", :params => request.protocol + request.host_with_port) }
    end
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = Conversation.new(conversation_params)

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to @conversation, notice: 'Conversation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @conversation }
      else
        format.html { render action: 'new' }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to @conversation, notice: 'Conversation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to conversations_url }
      format.json { head :no_content }
    end
  end

  private
    # ask for token access
    def restrict_access
      if  session[:user_id]
        if !conversation_params.nil?
          conversation_params[:user_id] = session[:user_id]
        end
      else
        authenticate_or_request_with_http_token do |token, options|
          @user = User.where(:auth_token => token).first()
          if (@user)
            if !conversation_params.nil?
              conversation_params[:user_id] = @user.id
            end
            return true
          end
          false
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params[:conversation]
    end
end
