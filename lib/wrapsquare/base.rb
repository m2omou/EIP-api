module Wrapsquare
  class Base

    API_URL = "https://api.foursquare.com/v2/venues/"

    def initialize(args = {})
      @oauth_token = args.fetch(:oauth_token, nil)
      @version = args.fetch(:version, nil)
      @user_id = args.fetch(:user_id, nil)

      if @oauth_token.nil? || @oauth_token.nil?
        raise ArgumentError, "You need to pass the oauth_token and the version"
      end
    end

    def venues()
      Wrapsquare::Venues.new(self, @user_id)
    end

    # make an http GET request to foursquare API and parse the json response
    def get(path, params={})
      params = merge_set_up_params(params)
      JSON.parse(Typhoeus::Request.get(API_URL + path, :params => params).body)["response"]
    end

    private

    # merge the token & version to the parameters
    def merge_set_up_params(params)
      if (!@oauth_token.nil? && !@version.nil?)
        params.merge!(:oauth_token => @oauth_token)
        params.merge(:v => @version)
      end
    end

  end
end