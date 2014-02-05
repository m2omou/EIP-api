class PlaceMessage < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :place_id, :user_id, :content
end
