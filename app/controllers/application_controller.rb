# This controller is inherit by all the other controller. That means that
# all the functions that this controller have can be use in every controller.
class ApplicationController < ActionController::Base
  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token


  helper_method :current_user

  private


  module BackOfficeRoles
    STANDARD = 0
    MODERATOR = 1
    ADMIN = 2
  end

  # This function allows to access to the current user which
  # is authenticate on the website. If there is no user which is
  # authenticate, this function return nil. You have to use this function
  # to check the authentification of a user.
  def current_user
    begin
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    rescue ActiveRecord::RecordNotFound => e
      @current_user ||= nil
    end
  end

  def get_auth_token_user_id()
    if request.headers["Authorization"]
      @token = request.headers["Authorization"].scan(/\"(.*?)\"/)
      @user = User.where(:auth_token => @token).first()
    end
    return @user ? @user.id : session[:user_id]
  end
end
