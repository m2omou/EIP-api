class Message < ActiveRecord::Base
  attr_accessible :user_id, :conversation_id, :content
  belongs_to :user
  belongs_to :conversation
end
