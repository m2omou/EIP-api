json.array!(@report_comments) do |report_comment|
  json.extract! report_comment, :comment_id, :reason, :content, :user_id
  json.url report_comment_url(report_comment, format: :json)
end
