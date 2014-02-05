class Report < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :user_id, :publication_id
end
