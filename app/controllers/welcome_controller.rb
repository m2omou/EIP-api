class WelcomeController < ApplicationController
  def index
    flash[:page] = nil
  end
end
