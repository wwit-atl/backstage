require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Backstage
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.action_mailer.default_url_options = { host: 'localhost' }

    config.i18n.enforce_available_locales = true

    # ActionMailer Settings
    config.action_mailer.default_url_options = {  host: ENV['RAILS_HOST'] || 'backstage.wholeworldtheatre.com'  }
    config.action_mailer.smtp_settings = {
        :domain =>         ENV['MANDRILL_DOMAIN']       || 'wholeworldtheatre.com',
        :port =>           ENV['MANDRILL_SMTP_PORT']    || '587',
        :address =>        ENV['MANDRILL_SMTP_ADDRESS'] || 'smtp.mandrillapp.com',
        :user_name =>      ENV['MANDRILL_USERNAME'],
        :password =>       ENV['MANDRILL_TESTING'] != 'true' ? ENV['MANDRILL_APIKEY'] : ENV['MANDRILL_TEST_APIKEY'],
        :authentication => :plain
    }
    config.action_mailer.default_options = { from: 'Laughing Larry <larry@wholeworldtheatre.com>' }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = ( ENV['NO_EMAIL'] != 'true' )
  end
end
