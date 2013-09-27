source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'haml', '~> 4.0.0'
gem 'haml-rails'

# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bcrypt-ruby', '~> 3.0.0'

gem 'devise'
gem 'rolify', github: 'EppO/rolify'

gem 'simple_form'
gem 'bourbon'
gem 'neat'

gem 'delayed_job_active_record', '>= 4.0.0'
gem 'email_validator'
gem 'flutie'
gem 'recipient_interceptor'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'guard'
  gem 'guard-minitest'
  #gem 'guard-growl'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'hirb'
  gem 'minitest'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'guard'
  gem 'guard-minitest'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent'

end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :staging, :production do
  gem 'newrelic_rpm', '>= 3.6.7'
  gem 'rails_12factor'
end

# Rails Server
gem 'unicorn'

