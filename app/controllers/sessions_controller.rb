class SessionsController < ApplicationController
  def new
     flash[:page] = "login"
  end

  def create
    respond_to do |format|
    
      if user = User.authenticate(params[:email], params[:password])
        
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        format.html { redirect_to "/", :notice => "Logged in!" }
        format.json { render json: user, :except=>  [ :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
        session[:user_id] = user.id
      else
        format.html { redirect_to log_in_path, :notice => "Invalid email or password."}
        format.json { render json: "Error : Invalid email or password." }
        flash.now.alert = "Invalid email or password"
       
      end
    end
  end
  
  def destroy
    flash[:notice] = nil
    session[:user_id] = nil
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "Logged out!"
  end
end
