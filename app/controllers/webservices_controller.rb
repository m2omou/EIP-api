class WebservicesController < ApplicationController
  before_action :set_webservice, only: [:show, :edit, :update, :destroy]

  # GET /webservices
  # GET /webservices.json
  def index
    render layout: "webservice"
    @webservices = Webservice.all
  end

  def advertising
    render layout: "webservice"
  end
  
  def user
    render layout: "webservice"
  end
  
  def place
    render layout: "webservice"
  end
  
  def category
    render layout: "webservice"
  end
  
  def media
    render layout: "webservice"
  end
  
  def placemessage
    render layout: "webservice"
  end
  
  def publication
    render layout: "webservice"
  end
  
  def relationship
    render layout: "webservice"
  end
  
  def report
    render layout: "webservice"
  end
  
  def company
    render layout: "webservice"
  end
  
  def vote
    render layout: "webservice"
  end
  
  def login
    render layout: "webservice"
  end
  
  def resetpassword
    render layout: "webservice"
  end
  

end
