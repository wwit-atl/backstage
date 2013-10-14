json.array!(@conflicts) do |conflict|
  json.extract! conflict, :date, :member_id
  json.url conflict_url(conflict, format: :json)
end
