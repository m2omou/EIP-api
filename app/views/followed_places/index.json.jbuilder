json.array!(@followed_places) do |followed_place|
  json.extract! followed_place, :user_id, :place_id
  json.url followed_place_url(followed_place, format: :json)
end
