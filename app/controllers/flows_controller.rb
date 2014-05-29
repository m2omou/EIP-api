class FlowsController < ApplicationController
  before_filter :restrict_access

  # GET /flows
  # GET /flows.json
  def index
    @auth_user_id = get_auth_token_user_id()

    @user_id = @auth_user_id == -1 ? params[:user_id] : @auth_user_id
    @count = params.has_key?(:count) ? params[:count] : 20
    @since_id = params.has_key?(:since_id) ? params[:since_id] : 0
    @max_id = params.has_key?(:max_id) ? params[:max_id] : -1

    @query = "id > #{@since_id}"
    if (@max_id != -1)
      @query += " AND id < #{@max_id}"
    end
    respond_to do |format|
        @user = User.find(@user_id)
        @publications = Publication.where(:place_id => @user.followed_places.map(&:place_id))
                                   .where(@query)
                                   .order("id DESC")
                                   .limit(@count)
        @data = {:responseCode => 0, :responseMessage => "success", :result => {:publications => @publications}}
      format.html
      format.json { render :json => @data.as_json(:params => request.protocol + request.host_with_port,
                                                  :auth_user_id => get_auth_token_user_id()) }
    end
  end

  private

  def restrict_access
    unless  session[:user_id]
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
