class UsersController < ApplicationController
  
  before_filter :restrict_access, :except => [:new, :create]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @data = [:resposeCode => 0, :responseMessage => "success", :result => @users]
    respond_to do |format|
      format.html
      format.json { render json: @data, :except=>  [:auth_token, :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
    end
  end
  
  def login
     render layout: "application"
    @user = User.new
  end

  # GET /users/1
  # GET /users/1.json
  def show
    
    begin
      @user = User.find(params[:id])
      @data = {:resposeCode => 0, :responseMessage => "success", :result => @user}
    rescue ActiveRecord::RecordNotFound => e
      @data = {:resposeCode => 1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end

    respond_to do |format|
      format.html
      format.json { render json: @data, :except=>  [:auth_token, :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
    end
  end

  # GET /users/new
  def new
    flash[:page] = "register"
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        if params[:remember_me]
          cookies.permanent[:auth_token] = @user.auth_token
        else
          cookies[:auth_token] = @user.auth_token
        end
        session[:user_id] = @user.id
        @data = {:resposeCode => 0, :responseMessage => "User was successfully created", :result => @user}
        format.html { redirect_to "/", notice: 'User was successfully created.' }
        format.json { render json: @data, status: :unprocessable_entity, :except=>  [:password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
      else
        @data = {:resposeCode => 1, :responseMessage => "An error occurred while creating user accounts", :result => @user.errors}
        format.html { render action: 'new' }
        format.json { render json: @data, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
      begin
        @user = User.find(params[:id])
        respond_to do |format|
          if @user.update(user_params)
            @data = {:resposeCode => 0, :responseMessage => "User was successfully updated", :result => @user}
            format.html { redirect_to @user, notice: 'User was successfully updated.' }
            format.json { render json: @data, :except=>  [:password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
          else
            @data = {:resposeCode => 1, :responseMessage => "An error occurred while updated user details", :result => @user.errors}
            format.html { render action: 'edit' }
            format.json { render json: @data, status: :unprocessable_entity}
          end
        end
      rescue ActiveRecord::RecordNotFound => e
        respond_to do |format|
          @data = {:resposeCode => 1, :responseMessage => "Record not found", :result => {:error => e.message}}
          format.json { render json: @data, status: :unprocessable_entity}
        end
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
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
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
   
    def user_params
      params.require(:user).permit(:username, :firstname, :lastname, :email, :password,
                                   :password_confirmation, :avatar)
    end
    
end
