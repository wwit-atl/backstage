require 'test_helper'

class ShiftTest < ActiveSupport::TestCase

  def setup
    @shift = create(:shift)
  end

  test 'Cannot create without show_id' do
    @shift = build(:shift, show: nil)
    refute @shift.valid?, 'Allows create without a show id'
  end

  test 'Cannot create without skill_id' do
    @shift = build(:shift, skill: nil)
    refute @shift.valid?, 'Allows create without a skill_id'
  end

  test 'Can assign member' do
    @shift = create(:shift, member: nil)
    @member = create(:member)

    @shift.member = @member
    assert_equal @member.name, @shift.member.name
  end

  test 'scope with_code returns record with the given skill code' do
    assert_equal 'SS', Shift.with_code(:ss).first.skill.code
  end
end
