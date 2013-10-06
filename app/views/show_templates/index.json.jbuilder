json.array!(@show_templates) do |show_template|
  json.extract! show_template, :name, :dow, :showtime, :calltime
  json.url show_template_url(show_template, format: :json)
end
