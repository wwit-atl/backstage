require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase

  test 'can_be_scheduled model responds to schedule method' do
    assert build(:shift).respond_to?(:schedule), 'Model does not respond to schedule'
  end

end
