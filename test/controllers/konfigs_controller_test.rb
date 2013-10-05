require "test_helper"

class KonfigsControllerTest < ActionController::TestCase

  before do
    @konfig = konfigs(:one)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:konfigs)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Konfig.count') do
      post :create, konfig: {  }
    end

    assert_redirected_to konfig_path(assigns(:konfig))
  end

  def test_show
    get :show, id: @konfig
    assert_response :success
  end

  def test_edit
    get :edit, id: @konfig
    assert_response :success
  end

  def test_update
    put :update, id: @konfig, konfig: {  }
    assert_redirected_to konfig_path(assigns(:konfig))
  end

  def test_destroy
    assert_difference('Konfig.count', -1) do
      delete :destroy, id: @konfig
    end

    assert_redirected_to konfigs_path
  end
end
