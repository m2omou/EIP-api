class Category < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :name, :description
end
