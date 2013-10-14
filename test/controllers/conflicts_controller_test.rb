require "test_helper"

class ConflictsControllerTest < ActionController::TestCase

  before do
    @conflict = conflicts(:one)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:conflicts)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Conflict.count') do
      post :create, conflict: {  }
    end

    assert_redirected_to conflict_path(assigns(:conflict))
  end

  def test_show
    get :show, id: @conflict
    assert_response :success
  end

  def test_edit
    get :edit, id: @conflict
    assert_response :success
  end

  def test_update
    put :update, id: @conflict, conflict: {  }
    assert_redirected_to conflict_path(assigns(:conflict))
  end

  def test_destroy
    assert_difference('Conflict.count', -1) do
      delete :destroy, id: @conflict
    end

    assert_redirected_to conflicts_path
  end
end
