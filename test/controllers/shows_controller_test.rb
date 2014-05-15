require "test_helper"

class ShowsControllerTest < ActionController::TestCase

  def setup
    @show = FactoryGirl.create(:show)
    @member = FactoryGirl.create(:member, :admin)
    sign_in @member
  end

  test 'Get Show index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:shows)
  end

  test 'Get new Show' do
    @member = FactoryGirl.build(:member)
    get :new
    assert_response :success
  end

  test 'create new Show' do
    assert_difference('Show.count') do
      post :create, show: FactoryGirl.attributes_for(:show, date: Date.today)
    end

    assert_redirected_to show_path(assigns(:show))
  end

  test 'Display a Show' do
    get :show, id: @show
    assert_response :success
  end

  test 'Edit a Show' do
    get :edit, id: @show
    assert_response :success
  end

  test 'Update a Show' do
    patch :update, id: @show, show: FactoryGirl.attributes_for(:show)
    assert_redirected_to show_path(assigns(:show))
  end

  test 'Destroy a Show' do
    assert_difference('Show.count', -1) do
      delete :destroy, id: @show
    end

    assert_redirected_to shows_path
  end

end
