require "test_helper"

class ApiKeyTest < ActiveSupport::TestCase

  def setup
    @api_key = ApiKey.new
  end

  test 'must be valid' do
    assert @api_key.valid?
  end

  test 'should create access_token before save' do
    assert_nil @api_key.access_token

    @api_key.save

    refute_nil @api_key.access_token
  end

end
