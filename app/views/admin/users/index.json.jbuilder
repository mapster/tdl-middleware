json.array!(@users) do |user|
  json.partial! user
  json._url admin_user_url(user, format: :json)
end
