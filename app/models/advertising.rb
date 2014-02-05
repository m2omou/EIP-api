class Advertising < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :place_id, :company_id, :title, :type
end
