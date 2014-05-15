require "test_helper"

class KonfigTest < ActiveSupport::TestCase
  def setup
    FactoryGirl.create(:konfig, name: 'MemberMinShifts',    value: 3)
    FactoryGirl.create(:konfig, name: 'MemberMaxShifts',    value: 4)
    FactoryGirl.create(:konfig, name: 'MemberMaxConflicts', value: 4)
    FactoryGirl.create(:konfig, name: 'CastMinShows',       value: 5)
    Konfig.load!
  end

  test 'Config responds to member_min_shifts' do
    assert Konfig.respond_to?(:member_min_shifts), "Konfig does not respond to 'member_min_shifts'"
    assert_equal 3, Konfig.member_min_shifts
  end

  test 'Config responds to member_max_shifts' do
    assert Konfig.respond_to?(:member_max_shifts), "Konfig does not respond to 'member_max_shifts'"
    assert_equal 4, Konfig.member_max_shifts
  end

  test 'Config responds to member_max_conflicts' do
    assert Konfig.respond_to?(:member_max_conflicts), "Konfig does not respond to 'member_max_conflicts'"
    assert_equal 4, Konfig.member_max_conflicts
  end
end
