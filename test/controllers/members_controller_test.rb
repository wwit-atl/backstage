require 'minitest_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = Member.create(attributes_for(:member))
    @member.confirm! if @member.respond_to?('confirm!')
    @member.add_role :admin
    sign_in :member, @member
  end

  test "should get sign_in page when not signed in" do
    sign_out @member
    get :index
    assert_response(302)
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
      post :create, member: attributes_for(:member, lastname: 'uniqueperson')
    end

    assert_redirected_to members_path(notice: 'Member was successfully created.')
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
    assert_redirected_to members_path(notice: 'Member was successfully updated.')
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete :destroy, id: @member
    end

    assert_redirected_to members_path
  end
end
