require "test_helper"

# Add the following to your Rake file to test routes by default:
#   MiniTest::Rails::Testing.default_tasks << "routes"

class RouteTest < ActionDispatch::IntegrationTest
  test 'default route points to members#show' do
    assert_routing '/', controller: 'members', action: 'show'
  end
end
