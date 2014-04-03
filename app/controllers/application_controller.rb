# This controller is inherit by all the other controller. That means that
# all the functions that this controller have can be use in every controller.
class ApplicationController < ActionController::Base



  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token


  helper_method :current_user

  before_filter :set_locale

  private
  
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

private
  def set_locale
    # Set the I18n.locale value in order to load the correct language. By default it is fr.
  end
end
