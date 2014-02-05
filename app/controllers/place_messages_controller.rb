class PlaceMessagesController < ApplicationController
  before_action :set_place_message, only: [:show, :edit, :update, :destroy]

  # GET /place_messages
  # GET /place_messages.json
  def index
    @place_messages = PlaceMessage.all
    respond_to do |format|
      format.html
      format.json { render json: @place_messages }
    end
  end

  # GET /place_messages/1
  # GET /place_messages/1.json
  def show
  end

  # GET /place_messages/new
  def new
    @place_message = PlaceMessage.new
  end

  # GET /place_messages/1/edit
  def edit
  end

  # POST /place_messages
  # POST /place_messages.json
  def create
    @place_message = PlaceMessage.new(place_message_params)

    respond_to do |format|
      if @place_message.save
        format.html { redirect_to @place_message, notice: 'Place message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @place_message }
      else
        format.html { render action: 'new' }
        format.json { render json: @place_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /place_messages/1
  # PATCH/PUT /place_messages/1.json
  def update
    respond_to do |format|
      if @place_message.update(place_message_params)
        format.html { redirect_to @place_message, notice: 'Place message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @place_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /place_messages/1
  # DELETE /place_messages/1.json
  def destroy
    @place_message.destroy
    respond_to do |format|
      format.html { redirect_to place_messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place_message
      @place_message = PlaceMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_message_params
      params[:place_message]
    end
end
