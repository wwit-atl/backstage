Airbrake.configure do |config|
  config.project_key = '975c8408c0ba86574b0344c37eec36b5'
  config.project_id  = 109790

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
