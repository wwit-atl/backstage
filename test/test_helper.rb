ENV['RAILS_ENV']  ||= 'test'
ENV['RAILS_HOST'] ||= 'test.host'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/factory_girl'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

if ENV['RUBYMINE_TESTUNIT_REPORTER']
  MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter
else
  #MiniTest::Reporters.use! MiniTest::Reporters::DefaultReporter.new
  MiniTest::Reporters.use! MiniTest::Reporters::ProgressReporter.new
  #MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
  #MiniTest::Reporters.use! MiniTest::Reporters::GuardReporter.new
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  DatabaseCleaner.strategy = :transaction

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

