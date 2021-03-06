require 'test_helper'

class MembersControllerTest < ActionController::TestCase

  def setup
    @member = FactoryGirl.create(:member, :admin)
    sign_in @member
  end

  test "should get sign_in page when not signed in" do
    sign_out @member
    get :index
    assert_response 302, :sign_in_path
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create member" do
    assert_difference('Member.count') do
      post :create, member: FactoryGirl.attributes_for(:member, lastname: 'unique')
    end

    assert_redirected_to members_path
  end

  test "should show member" do
    get :show, id: @member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @member
    assert_response :success
  end

  test "should update member" do
    patch :update, id: @member, member: { email: @member.email, firstname: @member.firstname, lastname: @member.lastname }
    assert_redirected_to member_path(@member)
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete :destroy, id: @member
    end

    assert_redirected_to members_path
  end
end
