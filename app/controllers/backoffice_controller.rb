class BackofficeController < ApplicationController
  before_filter :current_user

  layout "application"


  def index
    respond_to do |format|
      format.html
    end
  end

end
