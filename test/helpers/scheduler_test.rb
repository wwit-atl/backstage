require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase

  def setup
    create(:konfig, name: 'MemberMinShifts', value: 3)
    create(:konfig, name: 'MemberMaxShifts', value: 5)
    create(:role, name: 'us', cast: 'true', crew: 'true')
    create(:role, name: 'isp', cast: 'true', crew: 'true')
  end

  def create_show(group = :us)
    show = create(:show, :skills, group)
    assert_equal group.to_s, show.group.name, 'Show not assigned to proper group'

    skill = show.skills.where(code: 'HM').first
    assert_equal 'HM', skill.code, 'Could not obtain HM Skill for testing'

    shift = show.shifts.with_skill(:hm)
    assert_equal skill.code, shift.skill.code, 'Shift does not match skill requirement'

    show
  end

  def create_member(group = :us)
    member = create :member, group.to_sym, :train_hm
    assert member.skills.pluck(:code).include?('HM'), 'Crew member not trained for HM'
    assert member.is_crewable?, 'Crew member is not crewable'

    member
  end

  test 'can_be_scheduled model responds to schedule method' do
    assert build(:show).respond_to?(:schedule), 'Model does not respond to schedule'
  end

  test 'schedule shows' do
    us_show    = create_show(:us)
    us_member  = create_member(:us)

    isp_show   = create_show(:isp)
    isp_member = create_member(:isp)

    assert_equal 2, Member.crewable.count, 'There are not two crew members to test schedule'

    us_show.schedule

    assert_equal isp_member, us_show.shifts.with_skill(:hm).member, 'Schedule does not assign ISP member to US shift'
    refute_equal us_member,  us_show.shifts.with_skill(:hm).member, 'Schedule assigns US member to US shift'

    isp_show.schedule

    assert_equal us_member,  isp_show.shifts.with_skill(:hm).member, 'Schedule does not assign US member to ISP shift'
    refute_equal isp_member, isp_show.shifts.with_skill(:hm).member, 'Schedule assigns ISP member to ISP shift'
  end

end
