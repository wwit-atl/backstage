require "test_helper"

class MessagesControllerTest < ActionController::TestCase

  before do
    @message = messages(:one)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Message.count') do
      post :create, message: {  }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  def test_show
    get :show, id: @message
    assert_response :success
  end

  def test_edit
    get :edit, id: @message
    assert_response :success
  end

  def test_update
    put :update, id: @message, message: {  }
    assert_redirected_to message_path(assigns(:message))
  end

  def test_destroy
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
    end

    assert_redirected_to messages_path
  end
end
