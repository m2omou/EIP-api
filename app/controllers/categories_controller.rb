class CategoriesController < ApplicationController
  require "wrapsquare/base"
  require "wrapsquare/categories"

  def index
    # set the foursquare token and version
    @foursquare = Wrapsquare::Base.new(:oauth_token  => "KTJ1J4EKELCSQ5TKGIZTNQ1PWB5Q2W5SYV3QXDGV2BC4TISG",
                                       :version      => "20131129")
    # get the venues's category
    @categories = @foursquare.categories.show()
    render json: ApplicationHelper.jsonResponseFormat(0, "success",
                                  {:categories => @categories["categories"].map { |v| [v["id"], v["name"]] }})
  end
end
