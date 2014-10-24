class BackofficeController < ApplicationController
  before_filter :restrict_access

  layout "application"


  def index
    respond_to do |format|
      format.html
    end
  end

  private

  # ask for token access
  def restrict_access
    if  session[:user_id]

    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)

          return true
        end
        false
      end
    end
  end

end
