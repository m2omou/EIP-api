json.array!(@settings) do |setting|
  json.extract! setting, :allow_messages, :send_notification_for_comments, :send_notification_for_messages, :user_id
  json.url setting_url(setting, format: :json)
end
