require "test_helper"

class ShowsControllerTest < ActionController::TestCase

  def setup
    @show = create(:show)
    @member = create(:member)
    sign_in @member
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:shows)
  end

  def test_new
    @member = build(:member)
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Show.count') do
      post :create, show: attributes_for(:show, date: Date.today)
    end

    assert_redirected_to show_path(assigns(:show))
  end

  def test_show
    get :show, id: @show
    assert_response :success
  end

  def test_edit
    get :edit, id: @show
    assert_response :success
  end

  def test_update
    patch :update, id: @show, show: attributes_for(:show)
    assert_redirected_to show_path(assigns(:show))
  end

  def test_destroy
    assert_difference('Show.count', -1) do
      delete :destroy, id: @show
    end

    assert_redirected_to shows_path
  end
end
