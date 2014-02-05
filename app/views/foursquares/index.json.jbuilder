json.array!(@foursquares) do |foursquare|
  json.extract! foursquare, 
  json.url foursquare_url(foursquare, format: :json)
end
