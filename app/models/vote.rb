class Vote < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :publication_id, :user_id, :value
  belongs_to :user
  belongs_to :publication
end
