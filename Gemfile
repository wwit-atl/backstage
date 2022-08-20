source 'https://rubygems.org'
ruby '2.6.10'

gem 'rails', '~> 4.2'
gem 'nokogiri', '~> 1.6.5'
gem 'pg', '~> 0.18'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4'
gem 'haml', '~> 4.0.0'
gem 'haml-rails'
gem 'bootstrap-sass', '~> 3'
gem 'sass-rails', '>= 3'
gem 'autoprefixer-rails', '~> 4'
gem 'will_paginate-bootstrap'

gem "bigdecimal", "~> 1.3.5"
gem 'psych', '< 4'
gem 'jquery-rails', '~> 3'
gem 'jquery-ui-rails'
gem 'jquery-timepicker-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bcrypt', '~> 3'
gem 'acts_as_list'
gem 'cocoon'
gem 'devise', git: 'https://github.com/plataformatec/devise' , branch: '3-stable'
gem 'rolify', '~> 3'
gem 'cancancan'
gem 'chosen-rails'
gem 'mandrill-rails'
gem 'simple_form'
gem 'redcarpet'
gem 'friendly_id', '~> 5'
gem 'delayed_job_active_record', '>= 4.0.0'
gem 'recurring_job'
gem 'daemons'
gem 'email_validator'
gem 'recipient_interceptor'
gem 'icalendar'
gem 'bootstrap-editable-rails'
gem 'whenever', require: false
gem 'newrelic_rpm', '~> 3.7'
gem 'paperclip', '~> 4.2'
gem 'aws-sdk', '< 2.0'
gem 'airbrake'
gem 'therubyracer', :group => :production
gem 'compass-rails', '~> 2.0.2'

gem 'factory_girl_rails'
gem 'faker'

group :staging do
  # Needed for Heroku
  gem 'rails_12factor'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'dotenv-rails'
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'pry-rails'
  gem 'hirb'
  gem 'minitest'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'guard'
  gem 'guard-minitest'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: nil
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 1.0', require: false
end

# Rails Server
gem 'unicorn'
