require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV']  ||= 'test'
ENV['RAILS_HOST'] ||= 'test.host'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

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
  include FactoryGirl::Syntax::Methods

  ActiveRecord::Migration.check_pending!
  ActiveRecord::Migration.maintain_test_schema!


  DatabaseCleaner.strategy = :transaction

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def load_config
    FactoryGirl.create(:konfig, name: 'MemberMinShifts',    value: 3)
    FactoryGirl.create(:konfig, name: 'MemberMaxShifts',    value: 4)
    FactoryGirl.create(:konfig, name: 'MemberMaxConflicts', value: 4)
    FactoryGirl.create(:konfig, name: 'CastMinShows',       value: 5)
    Konfig.load! # Ensures the Konfig model creates methods for the items above
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

