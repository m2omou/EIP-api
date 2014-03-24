# This controller manages the first view of Neerbyy. Indeed,
# this load the index page, which redirects the user to the login page
# or the feed page if he is authenticated.
class WelcomeController < ApplicationController
	# The index method is load when the user access to the root of Neerbyy.
  def index
    flash[:page] = nil
  end
  
  def faq
    
  end
end
