class Vote < ActiveRecord::Base
self.inheritance_column = nil
  attr_accessible :id, :publication_id, :user_id, :value
end
