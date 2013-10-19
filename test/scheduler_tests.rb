require 'test_helper'

class ActsAsSchedulerTest < ActiveSupport::TestCase

  test 'acts_as_scheduler model responds to schedule method' do
    assert build(:show).respond_to?(:schedule), 'Model does not respond to schedule'
  end

end
