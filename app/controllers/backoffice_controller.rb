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
      if !comment_params.nil?
        comment_params[:user_id] = session[:user_id]
      end
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !comment_params.nil?
            comment_params[:user_id] = @user.id
          end
          return true
        end
        false
      end
    end
  end

end
