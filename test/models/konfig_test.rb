require "test_helper"

class KonfigTest < ActiveSupport::TestCase
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

  test 'Config responds to default_show_capacity' do
    skip 'Not yet implemented'
    assert Konfig.respond_to?(:default_show_capacity), "Konfig does not respond to 'member_max_conflicts'"
    assert_equal 123, Konfig.default_show_capacity
  end
end
