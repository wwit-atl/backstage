require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test 'code should display uppercase of name' do
    assert_equal 'TR', create(:role).code, 'role.code is not uppercase of name.'
  end
end
