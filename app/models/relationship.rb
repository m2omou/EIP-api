class Relationship < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :user_id, :place_id
  belongs_to :user
  belongs_to :place
end
