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

    config.i18n.enforce_available_locales = true

    # Currently, Active Record suppresses errors raised within after_rollback or after_commit callbacks and only
    # prints them to the logs. In the next version, these errors will no longer be suppressed. Instead, the errors will
    # propagate normally just like in other Active Record callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # ActionMailer Settings
    config.action_mailer.default_url_options = {  host: ENV['RAILS_HOST'] || 'backstage.wholeworldtheatre.com'  }

    config.action_mailer.smtp_settings = {
        :domain         => ENV['MANDRILL_DOMAIN']       || 'wholeworldtheatre.com',
        :port           => ENV['MANDRILL_SMTP_PORT']    || '587',
        :address        => ENV['MANDRILL_SMTP_ADDRESS'] || 'smtp.mandrillapp.com',
        :user_name      => ENV['MANDRILL_USERNAME'],
        :password       => ENV['MANDRILL_TESTING'] != 'true' ? ENV['MANDRILL_APIKEY'] : ENV['MANDRILL_TEST_APIKEY'],
        :authentication => :plain
    }

    config.action_mailer.default_options = {
        :from           => 'Laughing Larry <larry@wholeworldtheatre.com>',
        :to             => 'Laughing Larry <larry@wholeworldtheatre.com>',
        :reply_to       => ENV['DEFAULT_REPLY_TO'] || 'Eric Goins <eric@wholeworldtheatre.com>'
    }

    config.generators do |g|
      g.test_framework :minitest, spec: true, fixture: false
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = false if ENV['NO_EMAIL']
  end
end
