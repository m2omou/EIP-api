class Publication < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :user_id, :place_id, :title, :content, :file
  
  mount_uploader :file, FileUploader
  
end
