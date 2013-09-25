require "test_helper"

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "title should display titlecase of name" do
    assert 'Test Role' == create(:role).title
  end
end
