class FollowedPlace < ActiveRecord::Base
  require 'foursquare'

  attr_accessible :id, :user_id, :place_id

  # associations
  belongs_to :user

  # validations
  validates :place_id, :presence => {:message => "Please specify the place_id"}, :allow_blank => false

  def as_json(options={})
    hash = super(except)

    hash[:followed_place_id] = self.id
    hash[:id] = self.place_id

    if (options[:opt] == "index")
      if (!(@foursquare = options[:fq]).nil?)
        @place = @foursquare.venues.find(self.place_id)
        hash[:name] = @place.name
        hash[:address] = @place.address
        hash[:city] = @place.city
        hash[:country] = @place.country
        hash[:icon] = @place.icon
        hash[:latitude] = @place.latitude
        hash[:longitude] = @place.longitude
        hash[:postcode] = @place.postcode
      end
    end

    return hash
  end

  def except
    { :except => [ :updated_at, :created_at, :place_id, :user_id ] }
  end
end
