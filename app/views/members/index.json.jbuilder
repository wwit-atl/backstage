json.array!(@members) do |member|
  json.extract! member, :username, :lastname, :firstname, :email
  json.url member_url(member, format: :json)
end
