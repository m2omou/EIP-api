class MessagesController < ApplicationController
  before_filter :restrict_access

  # GET /messages
  # GET /messages.json
  # Get the list of messages for the authenticated user in the given conversation
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

      if (params.has_key?(:conversation_id))
        @messages = Message.where(conversation_id: params[:conversation_id]).where(@query).order("id " + @order).limit(@count)
        @messages = @order == "ASC" ? @messages.reverse : @messages
        @data = ApplicationHelper.jsonResponseFormat(0, "success", {:messages => @messages})
      else
        @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "Please send the conversation_id parameter"})
      end
      format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port) }
    end
  end

  # POST /messages
  # POST /messages.json
  # Send a message to the given user, if a conversation doesn't already exist
  # between the authenticated user and the recipient, then one is created.
  def create
    respond_to do |format|
      # check if the recipient_id exists
      if message_params.has_key?(:recipient_id) && !User.exists?(message_params[:recipient_id])
        @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "This user doesn't exists"})
        format.html { render action: 'new' }
        format.json { render json: @data }
      # check if the user is not sending a message to himself
      elsif message_params[:sender_id].to_s == message_params[:recipient_id].to_s
        @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "You can't send a message to yourself."})
        format.html { render action: 'new' }
        format.json { render json: @data }
      else
        # create new message
        @message = Message.new(message_params)

        # get parameters sender_id & recipient_id
        @user_id = message_params[:sender_id]
        @recipient_id = message_params[:recipient_id]

        # check if the conversation id exist
        if MessagesHelper.conversation_exist?(@user_id, @recipient_id)
          # create new conversation
          @message.create_conversation(:creator_id => @user_id, :recipient_id => @recipient_id)
        else
          # conversation between these two users already exist
          @message[:conversation_id] = MessagesHelper.find_conversation_id(@user_id, @recipient_id)
        end
        # save the message
        if @message.save
          @data = ApplicationHelper.jsonResponseFormat(0, "success", {:message => @message, :conversation => @message.conversation})
          format.html { redirect_to @message, notice: 'Message was successfully created.' }
          format.json { render json:  @data.as_json(:params => request.protocol + request.host_with_port) }
        else
          format.html { render action: 'new' }
          format.json { render json: ApplicationHelper.jsonResponseFormat(1, "Error", {:error => @message.errors}) }
        end
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:message => @message}}
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render json: @data }
      else
        @data = {:responseCode => 1, :responseMessage => "error", :result => @message.errors }
        format.html { render action: 'edit' }
        format.json { render json: @data }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    begin
      @message = Message.find(params[:id])
      # check if the owner of the message
      if (@message.user_id == get_auth_token_user_id())
        @message.destroy
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:message => "Message deleted"}}
      else
        @data = {:responseCode => -1, :responseMessage => "Must be the owner", :result => nil}
      end
    rescue ActiveRecord::RecordNotFound => e
      @data = {:responseCode => -1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { render json: @data }
    end
  end

  private
    # ask for token access
    def restrict_access
      if  session[:user_id]
        if !message_params.nil?
          message_params[:sender_id] = session[:user_id]
        end
      else
        authenticate_or_request_with_http_token do |token, options|
          @user = User.where(:auth_token => token).first()
          if (@user)
            if !message_params.nil?
              message_params[:sender_id] = @user.id
            end
            return true
          end
          false
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params[:message]
    end
end
