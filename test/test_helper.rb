ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/factory_girl'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

if ENV['RUBYMINE_TESTUNIT_REPORTER']
  MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter
else
  MiniTest::Reporters.use! MiniTest::Reporters::DefaultReporter.new
  #MiniTest::Reporters.use! MiniTest::Reporters::ProgressReporter.new
  #MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
end

class ActiveSupport::TestCase
  #include Devise::TestHelpers
  ActiveRecord::Migration.check_pending!

  # Add more helper methods to be used by all tests here...
end
