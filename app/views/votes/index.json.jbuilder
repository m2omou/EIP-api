json.array!(@votes) do |vote|
  json.extract! vote, 
  json.url vote_url(vote, format: :json)
end
