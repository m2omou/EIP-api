class Setting < ActiveRecord::Base
  attr_accessible :id, :user_id, :allow_messages, :send_notification_for_comments
  attr_accessible :send_notification_for_messages

  # associations
  belongs_to :user
end
