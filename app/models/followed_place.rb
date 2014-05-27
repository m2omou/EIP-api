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
      @place = Foursquare.find_place(self.place_id)
      hash[:address] = @place[:result][:place][:address]
      hash[:city] = @place[:result][:place][:city]
      hash[:country] = @place[:result][:place][:country]
      hash[:icon] = @place[:result][:place][:icon]
      hash[:latitude] = @place[:result][:place][:latitude]
      hash[:longitude] = @place[:result][:place][:longitude]
      hash[:postcode] = @place[:result][:place][:postcode]
    end

    return hash
  end

  def except
    { :except => [ :updated_at, :created_at, :place_id, :user_id ] }
  end
end
