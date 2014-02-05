class Company < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :name, :email, :address, :sector, :logo
end
