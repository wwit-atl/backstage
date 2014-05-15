require "test_helper"

class SkillsControllerTest < ActionController::TestCase

  def setup
    @member = FactoryGirl.create(:member, :admin)
    @skill = FactoryGirl.create(:skill)
    sign_in @member
  end

  test "should get sign_in page when not signed in" do
    sign_out @member
    get :index
    assert_response 302, :sign_in_path
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:skills)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Skill.count') do
      post :create, skill: FactoryGirl.attributes_for(:skill, code: 'UT', name: 'Unique Test')
    end

    assert_redirected_to skills_path
  end

  def test_edit
    get :edit, id: @skill
    assert_response :success
  end

  def test_update
    patch :update, id: @skill, skill: FactoryGirl.attributes_for(:skill)
    assert_redirected_to skills_path
  end

  def test_destroy
    assert_difference('Skill.count', -1) do
      delete :destroy, id: @skill
    end

    assert_redirected_to skills_path
  end
end
