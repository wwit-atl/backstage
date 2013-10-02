require "minitest_helper"

class SkillsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in :member, Member.create(FactoryGirl.attributes_for(:member))
    @skill = create(:skill)
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
      post :create, skill: attributes_for(:skill, name: 'UT', description: 'Unique Test')
    end

    assert_redirected_to skill_path(assigns(:skill))
  end

  def test_show
    get :show, id: @skill
    assert_response :success
  end

  def test_edit
    get :edit, id: @skill
    assert_response :success
  end

  def test_update
    patch :update, id: @skill, skill: attributes_for(:skill)
    assert_redirected_to skill_path(assigns(:skill))
  end

  def test_destroy
    assert_difference('Skill.count', -1) do
      delete :destroy, id: @skill
    end

    assert_redirected_to skills_path
  end
end
