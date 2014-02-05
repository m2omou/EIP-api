json.array!(@advertisings) do |advertising|
  json.extract! advertising, :id
  json.url advertising_url(advertising, format: :json)
end
