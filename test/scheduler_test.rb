require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase

  def setup
    create(:konfig, name: 'MemberMinShifts', value: 3)
    create(:konfig, name: 'MemberMaxShifts', value: 5)
  end

  test 'can_be_scheduled model responds to schedule method' do
    assert build(:show).respond_to?(:schedule), 'Model does not respond to schedule'
  end

  test 'schedule assigns member to shift' do
    show = create(:show, :skills)
    skill = create(:skill, code: 'HM', name: 'House Manager', training?: true, autocrew?: true),
    shift = create(:shift, show: show, skill: skill,  member: nil)

    crew_member = create :member, :us, :train_hm

    show.schedule

    assert_equal crew_member, shift.member, 'Schedule does not assign member to shift'
  end

end
