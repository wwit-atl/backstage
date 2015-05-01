# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load the app's custom environment variables here, so that they are loaded before environments/*.rb
app_environment_variables = File.join(Rails.root, 'config', 'app_environment_variables.rb')
load(app_environment_variables) if File.exists?(app_environment_variables)

Backstage::Application.configure do
  config.action_mailer.perform_deliveries  = false if ENV['NO_EMAIL']
  config.action_mailer.default_url_options = {  host: ENV['RAILS_HOST'] || 'backstage.wholeworldtheatre.com'  }
  config.action_mailer.delivery_method     = :smtp
  config.action_mailer.default_options     = {
      :from           => 'Laughing Larry <larry@wholeworldtheatre.com>',
      :to             => 'Laughing Larry <larry@wholeworldtheatre.com>',
      :reply_to       => ENV['DEFAULT_REPLY_TO'] || 'Eric Goins <eric@wholeworldtheatre.com>'
  }
  config.action_mailer.smtp_settings       = {
      :domain         => ENV['MANDRILL_DOMAIN']       || 'wholeworldtheatre.com',
      :port           => ENV['MANDRILL_SMTP_PORT']    || '587',
      :address        => ENV['MANDRILL_SMTP_ADDRESS'] || 'smtp.mandrillapp.com',
      :user_name      => ENV['MANDRILL_USERNAME'],
      :password       => ENV['MANDRILL_TESTING'] != 'true' ? ENV['MANDRILL_APIKEY'] : ENV['MANDRILL_TEST_APIKEY'],
      :authentication => :plain
  }
end

# Initialize the Rails application.
Backstage::Application.initialize!
