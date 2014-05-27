json.array!(@flows) do |flow|
  json.extract! flow,
  json.url flow_url(flow, format: :json)
end
