require 'test_helper'

class ShiftTest < ActiveSupport::TestCase

  def setup
    @shift = create(:shift)
  end

  #test 'Cannot create without show_id' do
  #  @shift = build(:shift, show: nil)
  #  refute @shift.valid?, 'Allows create without a show id'
  #end

  test 'Should assign the CAST skill by default' do
    @shift = create(:shift, skill: nil)
    assert @shift.valid?, 'Shift does not provide a default skill'
    assert_equal Skill.where(code: 'CAST').first, @shift.skill
  end

  test 'Can assign member' do
    @shift = create(:shift, member: nil)
    @member = create(:member)

    @shift.member = @member
    assert_equal @member.name, @shift.member.name
  end

  test 'scope with_skill returns record with the given skill code' do
    assert_equal 'SS', Shift.with_skill(:ss).skill.code
  end
end
