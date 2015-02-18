require "test_helper"

class Api::V1::MembersControllerTest < ActionController::TestCase

  def setup
    load_config

    @request.accept = 'application/vnd.backstage.v1'
    @member = FactoryGirl.create(:member, :with_conflicts)
    @show   = FactoryGirl.create(:show)
    sign_in @member
  end

  test "returns an array of conflicts when the version matches the 'Accept' header" do
    get :conflicts, member_id: @member.id, format: :json
    assert_response :success
    assert_equal @member.conflicts.ids, JSON.parse(@response.body, symbolize_names: true)
  end

  test "returns the default version when 'default' option is specified" do
    @request.accept = nil
    get :conflicts, member_id: @member.id, format: :json
    assert_response :success
  end

  test 'returns unauthorized when attempt to access another user conflicts' do
    new_member = FactoryGirl.create(:member)
    get :conflicts, member_id: new_member.id, format: :json
    assert_not_equal new_member.id, @member.id
    assert_response :forbidden
    assert_equal( { :status => 'forbidden' }, JSON.parse(@response.body, symbolize_names: true) )
  end

  # ToDo: Need to determine if a member has a conflict on a date given a show id
  test 'returns true when conflicts is called with a date which has a conflict' do
    @member.conflicts << FactoryGirl.create(:conflict, year: @show.date.year, month: @show.date.month, day: @show.date.day)
    get :conflicts, :format => :json, member_id: @member.id, for_show: @show.id
    assert_response :success
    assert_equal( { status: true }, JSON.parse(@response.body, symbolize_names: true) )
  end

  test 'returns false when conflicts is called with a date which does not have a conflict' do
    get :conflicts, :format => :json, member_id: @member.id, for_show: FactoryGirl.create(:show).id
    assert_response :success
    assert_equal( { status: false }, JSON.parse(@response.body, symbolize_names: true) )
  end

end
