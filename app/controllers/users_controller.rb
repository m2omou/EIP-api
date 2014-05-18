class UsersController < ApplicationController
  
  before_filter :restrict_access, :except => [:new, :create]
  helper_method :encrypt  

  # GET /users
  # GET /users.json
  
  def index
    @users = User.all
    
    @data = {:responseCode => 0, :responseMessage => "success", :result => {:users => @users}}
    respond_to do |format|
      format.html
      format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port), :except=>  [:auth_token, :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
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
      @data = {:responseCode => 0, :responseMessage => "success", :result => {:user => @user}}
    rescue ActiveRecord::RecordNotFound => e
      @data = {:responseCode => 1, :responseMessage => "Record not found", :result => {:error => e.message}}
    end

    respond_to do |format|
      format.html
      format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port), :except=>  [:auth_token, :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
    end
  end

  # GET /users/new
  def new
    flash[:page] = "register"
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
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
        @data = {:responseCode => 0, :responseMessage => "User was successfully created", :result => {:user => @user}}
        format.html { redirect_to "/", notice: 'User was successfully created.' }
        format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port), status: :unprocessable_entity, :except=>  [:password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
      else
        @data = {:responseCode => 1, :responseMessage => "An error occurred while creating user accounts", :result => {:error => @user.errors}}
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
        
        
        @user.save
        respond_to do |format|
          if @user.update(user_params)
            
            @user.firstname = @user.avatar_url
            @user.lastname = @user.avatar_url(:thumb)
            @user.save
            @data = {:responseCode => 0, :responseMessage => "User was successfully updated", :result => {:user => @user}}
            format.html { redirect_to @user, notice: 'User was successfully updated.' }
            format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port), :except=>  [:password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
          else
            @data = {:responseCode => 1, :responseMessage => "An error occurred while updated user details", :result => {:error => @user.errors}}
            format.html { render action: 'edit' }
            format.json { render json: @data, status: :unprocessable_entity}
          end
        end
      rescue ActiveRecord::RecordNotFound => e
        respond_to do |format|
          @data = {:responseCode => 1, :responseMessage => "Record not found", :result => {:error => e.message}}
          format.json { render json: @data, status: :unprocessable_entity}
        end
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    @data = {:responseCode => 0, :responseMessage => "User deleted", :result => {:user => @user}}
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { render json: @data }
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
        User.exists?(auth_token: token)
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
                                   :password_confirmation, :avatar, :avatar_url)
    end
    
end
