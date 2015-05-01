require "test_helper"

class MessagesControllerTest < ActionController::TestCase

  def setup
    @member = FactoryGirl.create(:member)
    @skill = FactoryGirl.create(:skill)
    sign_in @member
    @message = FactoryGirl.create(:message)
  end

  test 'should only send message to active members' do
    params = { :message => { :member_ids => [] } }

    # Create one extra inactive member
    inactive_member = FactoryGirl.create :member, active: false
    all_members = FactoryGirl.create_list( :member, 2, active: true ) << inactive_member

    # fill params with all members (active and inactive)
    all_members.each { |m| params[:message][:member_ids] << m.id }

    # Call our create method with all_members
    get :create, params
    assert_response :success

    # This is the params hash the create method receives, and should be filtered
    request_member_ids = @controller.params[:message][:member_ids]

    # Ensure it filtered out inactive members
    assert request_member_ids.count == 2, "parsed_members should have 2 items, but has #{request_member_ids.count}"
    assert_not_includes request_member_ids, inactive_member.id, 'request.params should not include inactive_members'
  end

end
