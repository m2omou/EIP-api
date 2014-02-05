json.array!(@media) do |medium|
  json.extract! medium, 
  json.url medium_url(medium, format: :json)
end
