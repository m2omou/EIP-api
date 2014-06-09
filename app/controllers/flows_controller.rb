class FlowsController < ApplicationController
  before_filter :restrict_access

  require "wrapsquare/base"
  require "wrapsquare/place"
  require "wrapsquare/venues"

  # GET /flows
  # GET /flows.json
  def index
    respond_to do |format|
      if (params.has_key?(:since_id) && params.has_key?(:max_id))
        format.json { render :json => ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "Please select either since_id or max_id"}) }
      else
        @auth_user_id = get_auth_token_user_id()
        @user_id = @auth_user_id == -1 ? params[:user_id] : @auth_user_id
        @count = params.has_key?(:count) ? ApplicationHelper.checkEmptyValue(params[:count]) : 20
        @since_id = params.has_key?(:since_id) ? ApplicationHelper.checkEmptyValue(params[:since_id]) : 0
        @max_id = params.has_key?(:max_id) ? ApplicationHelper.checkEmptyValue(params[:max_id]) : -1
        @order = "DESC"

        if (params.has_key?(:since_id))
          @query = "id > #{@since_id}"
          @order = "ASC"
        elsif (params.has_key?(:max_id))
          @query = "id < #{@max_id}"
        else
          @query = nil
        end

        @user = User.find(@user_id)
        @publications = Publication.where(:place_id => @user.followed_places.map(&:place_id)).where(@query).order("id " + @order).limit(@count)
        @publications = @order == "ASC" ? @publications.reverse : @publications
        @data = ApplicationHelper.jsonResponseFormat(0, "success", {:publications => @publications})

        # set the foursquare token and version
        @foursquare = Wrapsquare::Base.new(:oauth_token  => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                           :version      => "20131129", :user_id => get_auth_token_user_id())

        format.html
        format.json { render :json => @data.as_json(:params => request.protocol + request.host_with_port,
                                                    :auth_user_id => get_auth_token_user_id(),
                                                    :fq => @foursquare) }
      end
    end
  end

  private

  def restrict_access
    if  session[:user_id]
      if !flow_params.nil?
        flow_params[:user_id] = session[:user_id]
      end
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !flow_params.nil?
            flow_params[:user_id] = @user.id
          end
          return true
        end
        false
      end
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_flow

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flow_params
      params[:flow]
    end
end
