require 'minitest_helper'

class MemberTest < ActiveSupport::TestCase
  #def setup
  #  @member = create(:member)
  #end

  test "fullname should provide formatted firstname and lastname" do
    @member = create(:member, firstname: 'tester', lastname: 'testerson')
    assert 'Tester Testerson', @member.fullname
  end
end
