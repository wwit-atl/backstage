json.array!(@skills) do |skill|
  json.extract! skill, :name, :description
  json.url skill_url(skill, format: :json)
end
