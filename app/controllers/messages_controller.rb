class MessagesController < ApplicationController
  before_filter :restrict_access

  # GET /messages
  # GET /messages.json
  # Get the list of messages for the authenticated user in the given conversation
  def index

    # for the back office
    if (current_user && current_user.role == BackOfficeRoles::ADMIN)
      @messages = Message.all()
      return render :html => @messages
    end


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
        @user_id = get_auth_token_user_id()

        if (!Conversation.where("creator_id = ? or recipient_id = ?", @user_id, @user_id).exists? ||
            !Conversation.exists?(params[:conversation_id]))
          @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "You don't belong to this conversation"})
        else
          @messages = Message.where(conversation_id: params[:conversation_id])
                             .where(@query).order("id " + @order).limit(@count)

          @messages = @order == "ASC" ? @messages.reverse : @messages
          @data = ApplicationHelper.jsonResponseFormat(0, "success", {:messages => @messages})
        end
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

    # for the back office
    if (current_user && current_user.role == BackOfficeRoles::ADMIN)
      @message = Message.new(message_params)
      respond_to do |format|
        if @message.save
          format.html { redirect_to @message, :notice => 'Message was successfully created.' }
        else
          format.html { render :action => "new" }
        end
      end
      return
    end

      # check if the recipient_id exists
      if message_params.has_key?(:recipient_id) && !User.exists?(message_params[:recipient_id])
        render json: ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "This user doesn't exists"})
      # check if the user is not sending a message to himself
      elsif message_params[:sender_id].to_s == message_params[:recipient_id].to_s
        render json: ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "You can't send a message to yourself."})
      else
        # get parameters sender_id & recipient_id
        @user_id = message_params[:sender_id]
        @recipient_id = message_params[:recipient_id]

        # check the user's settings, see if messages are allowed
        if !User.find(@user_id).setting.allow_messages || !User.find(@recipient_id).setting.allow_messages
          render json: ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "Messages are not allowed"})
        else
          # create new message
          @message = Message.new(message_params)

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

            @recipient = User.find(@recipient_id)
            @sender =  User.find(@user_id)

            # send push notification
            n = Rpush::Apns::Notification.new
            n.app = Rpush::Apns::App.find_by_name("ios_app")
            n.device_token = @recipient.device_token
            n.alert =  "#{@sender.username} vous a envoye un message."
            n.data = { sender_id: @sender.id }
            n.save!
            # send
            Rpush.push


            @data = ApplicationHelper.jsonResponseFormat(0, "success", {:message => @message, :conversation => @message.conversation})
            render json:  @data.as_json(:params => request.protocol + request.host_with_port, :user_id => get_auth_token_user_id())
          else
            render json: ApplicationHelper.jsonResponseFormat(1, "Error", {:error => @message.errors})
          end
        end
    end
  end


  def new
    @message =  Message.new
  end

  def show
    @message =  Message.find(params[:id])
  end

  def edit
    @message =  Message.find(params[:id])
  end


  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

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
    if (current_user && current_user.role == BackOfficeRoles::ADMIN)
      @message = Message.find(params[:id])
      @message.destroy
    end

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
