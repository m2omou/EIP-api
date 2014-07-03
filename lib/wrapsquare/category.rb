module Wrapsquare
  class Category
    require 'json'

    def initialize(category)
      @category = category
    end

    def id
      @category["id"]
    end

    def name
      @category["name"]
    end

    # Serialize object into json
    def to_json(*a)
      {
          :id => self.id,
          :name => self.name
      }.to_json(*a)
    end

  end

end