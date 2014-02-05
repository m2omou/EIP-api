json.array!(@publications) do |publication|
  json.extract! publication, 
  json.url publication_url(publication, format: :json)
end
