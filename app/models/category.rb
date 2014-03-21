class Category < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :name, :description
  
  has_many :places
end
