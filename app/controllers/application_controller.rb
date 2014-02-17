class ApplicationController < ActionController::Base
  
  

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token


  helper_method :current_user
 
  private
  
  def current_user
begin
  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
rescue ActiveRecord::RecordNotFound => e
  @current_user ||= nil
end

  end
end
