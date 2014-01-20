source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.0'
gem 'pg'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'haml', '~> 4.0.0'
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 3.0.0'

# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-timepicker-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'acts_as_list'
gem 'will_paginate-bootstrap'
gem 'cocoon'

gem 'devise', '~> 3.1.0'
gem 'rolify', github: 'EppO/rolify' # Needed for Rails4 support
gem 'cancan'
gem 'select2-rails'

gem 'simple_form'

gem 'delayed_job_active_record', '>= 4.0.0'
gem 'email_validator'
gem 'recipient_interceptor'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'pry-rails'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'hirb'
  gem 'minitest'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'guard'
  gem 'guard-minitest'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent'
  gem 'database_cleaner'

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
#gem 'unicorn'
gem 'puma'

