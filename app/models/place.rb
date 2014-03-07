class Place < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :foursquare_id, :longitude, :latitude, :name, :postcode, :city, :address, :country
end
