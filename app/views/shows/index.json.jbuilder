json.array!(@shows) do |show|
  json.extract! show, :date, :showtime, :calltime
  json.url show_url(show, format: :json)
end
