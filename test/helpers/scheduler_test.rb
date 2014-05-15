require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase

  def setup
    FactoryGirl.create(:konfig, name: 'MemberMinShifts',    value: 3)
    FactoryGirl.create(:konfig, name: 'MemberMaxShifts',    value: 5)
    FactoryGirl.create(:konfig, name: 'MemberMaxConflicts', value: 4)

    FactoryGirl.create(:role, name: 'ms',        cast: 'true',  crew: 'true', schedule: 'false')
    FactoryGirl.create(:role, name: 'us',        cast: 'true',  crew: 'true', schedule: 'true')
    FactoryGirl.create(:role, name: 'isp',       cast: 'true',  crew: 'true', schedule: 'true')
    FactoryGirl.create(:role, name: 'volunteer', cast: 'false', crew: 'true', schedule: 'false')
  end

  def create_show(group = :us)
    show = FactoryGirl.create(:show, :skills, group)
    assert_equal group.to_s, show.group.name, 'Show not assigned to proper group'

    skill = show.skills.where(code: 'HM').first
    assert_equal 'HM', skill.code, 'Could not obtain HM Skill for testing'

    shift = show.shifts.with_skill(:hm)
    assert_equal skill.code, shift.skill.code, 'Shift does not match skill requirement'

    show
  end

  def create_member(group = :us)
    member = FactoryGirl.create :member, group.to_sym, :train_hm
    assert member.skills.pluck(:code).include?('HM'), 'Crew member not trained for HM'
    assert member.is_crewable?, 'Crew member is not crewable'

    member
  end

  test 'can_be_scheduled model responds to schedule method' do
    assert FactoryGirl.build(:shift).respond_to?(:schedule), 'Model does not respond to schedule'
  end

  ##
  # NOTE:  Must create shows before members, because show factory creates skills
  ##
  test 'schedule shows' do
    us_show    = create_show(:us)
    us_member  = create_member(:us)

    isp_show   = create_show(:isp)
    isp_member = create_member(:isp)

    assert_equal 2, Member.crewable.count, 'There are not two crew members to test schedule'

    Shift.schedule

    assert_equal isp_member, us_show.shifts.with_skill(:hm).member, 'Schedule does not assign ISP member to US shift'
    refute_equal us_member,  us_show.shifts.with_skill(:hm).member, 'Schedule assigns US member to US shift'

    assert_equal us_member,  isp_show.shifts.with_skill(:hm).member, 'Schedule does not assign US member to ISP shift'
    refute_equal isp_member, isp_show.shifts.with_skill(:hm).member, 'Schedule assigns ISP member to ISP shift'
  end

  test 'auto-schedules for ms shows' do
    show = create_show(:ms)
    member = FactoryGirl.create :member, :us, :train_hm

    assert_equal 1, Member.crewable.count, 'There are no crew members to test schedule'
    assert_equal 1, Member.crewable.has_skill(:hm).count, 'test did not create HM member'

    Shift.schedule

    assert_equal member, show.shifts.with_skill(:hm).member, 'Schedule auto-assigns volunteer members'
  end

  test 'does not auto-schedule volunteers' do
    show = create_show(:ms)
    FactoryGirl.create :member, :volunteer, :train_hm

    assert_equal 1, Member.crewable.count, 'There are no crew members to test schedule'
    assert_equal 1, Member.crewable.has_skill(:hm).count, 'test did not create HM member'

    Shift.schedule

    assert_equal nil, show.shifts.with_skill(:hm).member, 'Schedule auto-assigns volunteer members'
  end
end
