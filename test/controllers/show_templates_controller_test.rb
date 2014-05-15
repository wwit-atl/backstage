require "test_helper"

class ShowTemplatesControllerTest < ActionController::TestCase

  def setup
    @member = FactoryGirl.create(:member, :admin)
    sign_in @member
    @show_template = FactoryGirl.create(:show_template)
  end

  def teardown
    sign_out @member
    @member.destroy
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:show_templates)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('ShowTemplate.count') do
      post :create, show_template: FactoryGirl.attributes_for(:show_template)
    end

    assert_redirected_to show_templates_path
  end

  def test_edit
    get :edit, id: @show_template
    assert_response :success
  end

  def test_update
    patch :update, id: @show_template, show_template: FactoryGirl.attributes_for(:show_template, name: 'Unique Show')
    assert_redirected_to show_templates_path
  end

  def test_destroy
    assert_difference('ShowTemplate.count', -1) do
      delete :destroy, id: @show_template
    end

    assert_redirected_to show_templates_path
  end
end
