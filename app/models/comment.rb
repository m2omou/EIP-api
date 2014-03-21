class Comment < ActiveRecord::Base
  attr_accessible :id, :publication_id, :user_id, :content
  belongs_to :publication
  belongs_to :user
end
