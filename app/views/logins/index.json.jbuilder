json.array!(@logins) do |login|
  json.extract! login, 
  json.url login_url(login, format: :json)
end
