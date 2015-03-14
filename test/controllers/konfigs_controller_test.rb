require "test_helper"

class KonfigsControllerTest < ActionController::TestCase

  def setup
    @member = FactoryGirl.create(:member)
    sign_in @member
  end

  test 'cannot log in as member' do
    get :index
    assert_response 302, :sign_in_path
  end

  test 'can log in as admin' do
    sign_in FactoryGirl.create(:member, :admin)
    get :index
    assert_response :success
  end

end
