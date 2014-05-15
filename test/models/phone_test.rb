require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  setup do
    @phone = FactoryGirl.create(:phone, number: '1234567890', member_id: 1)
  end

  test "should not save without number" do
    phone = Phone.new
    assert !phone.save
  end

  test "should strip non-digits from number before a save" do
    @phone = FactoryGirl.create(:phone, number: '(098) 765-4321')
    assert :success
    assert_equal '0987654321', @phone.number
  end

  test "phone without 10 digits should fail" do
    phone = FactoryGirl.build(:phone, number: '1234567' )
    refute phone.valid?
    assert_raises( ActiveRecord::RecordInvalid ) { phone.save! }
  end

  test "npa returns area code" do
    assert_equal @phone.number[0..2], @phone.npa
  end

  test "fnumber formats 10 digit number" do
    assert_equal "123-456-7890", @phone.fnumber
  end
end
