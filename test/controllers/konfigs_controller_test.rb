require "test_helper"

class KonfigsControllerTest < ActionController::TestCase

  def setup
    @member = create(:member)
    sign_in @member
  end

  test "cannot log in as member" do
    get :index
    assert_response 401
  end

  test "can log in as admin" do
    sign_in create(:admin)
    get :index
    assert_response :success
  end

end
