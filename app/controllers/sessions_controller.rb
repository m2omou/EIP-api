# This controller is used in order to log in or log out the user.
# It is bind to the routes /log_out and /log_in
class SessionsController < ApplicationController
  # check if token exist
  before_filter :restrict_access, :only => [:destroy]

  layout "login"

  # This method is called when the user go to the route /log_in and
  # loads the view /views/sessions/new.html.erb
  def new
     flash[:page] = "login"
  end

  # This method is called when the user submit his email and password in the
  # view /log_in. If the authenticate succeed, he is redirected to /, otherwise
  # the page is reload with the error "Invalid email or password."
  def create
    respond_to do |format|
      if !params[:connection].nil? && user = User.authenticate(params[:connection][:email], params[:connection][:password])
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:user => user}}
        if params[:redirect]
          format.html { redirect_to params[:redirect] }
        else
          format.html { redirect_to "/backoffice", :notice => "Logged in!" }
        end

        # update device_token
        User.update(user.id, :device_token => params[:connection][:device_token],
                             :platform_id => params[:connection][:platform_id])


        format.json { render json: @data.as_json(:params => {:url => request.protocol + request.host_with_port}),
                             :except=>  [:password_hash, :password_salt, :password_reset_token, :password_reset_sent_at, :device_token] }
        session[:user_id] = user.id
      else
        @data = { :responseCode => 1, :responseMessage => "An error occurred while trying to login",
                  :result => {:error => "Invalid email or password."}
                }
        format.html { redirect_to log_in_path, :notice => "Invalid email or password."}
        format.json { render json: @data }
        flash.now.alert = "Invalid email or password"
      end
    end
  end

  # The logout method
  def destroy
    # remove token access
    @user_id = get_auth_token_user_id()
    if (User.exists?(@user_id))
      User.update(@user_id, :auth_token => nil, :device_token => nil)
    end
    # clear session
    reset_session
    flash[:notice] = nil
    #session[:user_id] = nil
    cookies.delete(:auth_token)
    @data = { :responseCode => 0, :responseMessage => "success", :result => nil }
    respond_to do |format|
      format.html { redirect_to "/admin", :notice => "Logged out!" }
      format.json { render json: @data }
    end
  end

  private

  # check if token exist
  def restrict_access
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        User.exists?(auth_token: token)
      end
    end
  end
end
