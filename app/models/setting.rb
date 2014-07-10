class Setting < ActiveRecord::Base
  attr_accessible :id, :user_id, :allow_messages, :send_notification_for_comments
  attr_accessible :send_notification_for_messages

  # associations
  belongs_to :user

  def as_json(options={})
    hash = super(except)
  end

  # hide certain information
  def except
    { :except=>  [ :updated_at, :created_at, :user_id] }
  end
end
