json.array!(@relationships) do |relationship|
  json.extract! relationship, 
  json.url relationship_url(relationship, format: :json)
end
