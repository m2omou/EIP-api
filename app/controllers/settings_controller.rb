class SettingsController < ApplicationController
  before_filter :restrict_access
  
  def index
    @user = User.find(session[:user_id])
  end
  
  private
  
  
  def restrict_access
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        User.exists?(auth_token: token, id: params[:user_id])
      end
    end
  end
end
