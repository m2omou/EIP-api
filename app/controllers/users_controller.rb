class UsersController < ApplicationController
  
  before_filter :restrict_access, :except => [:new, :create]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end
  
  def connexion
    
     if (params.has_key?(:email) && params.has_key?(:password))
        @connexion = User.where(email: params[:email], password: params[:password])
        @user = @connexion[0]
        if @connexion.empty?
          @user = { :error => 1, :message => "Wrong Username/Email and password combination." }
        end
     else
       @user = { :error => 1, :message => "Wrong Username/Email and password combination." }
     end
    respond_to do |format|
      format.html { redirect_to '/users/12' }
      format.json { render json: @user }
    end
  end
  
  def login
     render layout: "application"
    @user = User.new
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
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
        format.html { redirect_to "/", notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      @user = User.find_by_id(params[:id])
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
