json.array!(@configs) do |config|
  json.extract! config, :name, :value
  json.url config_url(config, format: :json)
end
