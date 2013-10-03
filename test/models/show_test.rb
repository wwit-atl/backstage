require "test_helper"

class ShowTest < ActiveSupport::TestCase

  test 'not valid without date' do
    show = build(:show, date: nil)
    refute show.valid?, 'Allows save without a date'
  end

end
