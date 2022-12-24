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

    # ActiveJob Queue Adapter
    # config.active_job.queue_adapter = :delayed_job

    config.generators do |g|
      g.test_framework :minitest, spec: true, fixture: false
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = false if ENV['NO_EMAIL']

    config.paperclip_defaults = {
        :storage         => :s3,
        :s3_credentials  => {
            access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
            bucket:            ENV['AWS_BUCKET']
        },
        :convert_options => { :all => '-strip' }
    }
    Paperclip.registered_attachments_styles_path = 'tmp/paperclip_attachments.yml'
  end
end
