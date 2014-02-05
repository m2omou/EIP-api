class Medium < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :type, :url, :server
end
