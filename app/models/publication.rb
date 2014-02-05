class Publication < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :user_id, :category_id, :media_id, :place_id, :title, :content
end
