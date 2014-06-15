class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_filter :restrict_access

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
    respond_to do |format|
      @data = ApplicationHelper.jsonResponseFormat(0, "success", {:message => @messages})
      format.json { render json: @data }
    end
  end

  # POST /messages
  # POST /messages.json
  def create


    puts "#{message_params[:sender_id]} == #{message_params[:recipient_id]}"

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

        # Send a message to the given user, if a conversation doesn't already exist
        # between the authenticated user and the recipient, then one is created.
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
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
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
