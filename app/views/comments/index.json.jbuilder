json.array!(@comments) do |comment|
  json.extract! comment,:id, :content, :publication_id, :user_id
  json.url comment_url(comment, format: :json)
end
