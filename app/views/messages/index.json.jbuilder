json.array!(@messages) do |message|
  json.extract! message, :content, :user_id, :conversation_id
  json.url message_url(message, format: :json)
end
