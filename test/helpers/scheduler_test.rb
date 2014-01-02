require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase

  def setup
    create(:konfig, name: 'MemberMinShifts', value: 3)
    create(:konfig, name: 'MemberMaxShifts', value: 5)
    create(:role, name: 'us', cast: 'true', crew: 'true')
  end

  test 'can_be_scheduled model responds to schedule method' do
    assert build(:show).respond_to?(:schedule), 'Model does not respond to schedule'
  end

  test 'schedule assigns member to shift' do
    show = create(:show, :skills, :with_shift)

    skill = show.skills.where(code: 'HM').first
    assert_equal 'HM', skill.code, 'Could not obtain HM Skill for testing'

    shift = show.shifts.with_skill(:hm)
    assert_equal skill.code, shift.skill.code, 'Shift does not match skill requirement'

    crew_member = create :member, :us, :train_hm
    assert_equal crew_member, Member.has_skill(shift.skill.code).first, 'Crew member not trained for HM'
    assert_equal crew_member, Member.crewable.first, 'Crew member is not crewable'

    show.schedule
    assert_equal crew_member, show.shifts.with_skill(:hm).member, 'Schedule does not assign member to shift'
  end

end
