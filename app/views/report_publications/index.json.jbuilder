json.array!(@report_publications) do |report_publication|
  json.extract! report_publication, :publication_id, :reason, :content, :user_id
  json.url report_publication_url(report_publication, format: :json)
end
