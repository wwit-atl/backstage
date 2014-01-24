require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'not valid without email' do
    user = build(:member, email: nil)
    refute user.valid?, 'Allows save without an email'
  end

  test 'not valid without firstname' do
    user = build(:member, firstname: nil, email: 'test@example.org')
    refute user.valid?, 'Allows save without a firstname'
  end

  test 'not valid without lastname' do
    user = build(:member, lastname: nil, email: 'test@example.org')
    refute user.valid?, 'Allows save without a lastname'
  end

  test 'email must be unique' do
    email = 'test@example.org'
    create(:member, email: email)
    assert_raises( ActiveRecord::RecordInvalid ) { create(:member, email: email) }
  end

  test 'fullname should provide formatted firstname and lastname' do
    assert_equal 'Tester Testerson', build(:member, firstname: 'tester', lastname: 'testerson').fullname
  end

  test 'castable members' do
    create( :role, name: :cast, cast: true, crew: false )
    member = create(:member, :cast)
    assert_equal member, Member.castable.first, 'Cast member should be castable, but is not.'
    refute_equal member, Member.crewable.first, 'Cast member should not be crewable, but is.'
  end

  test 'crewable members' do
    create( :role, name: :crew, cast: false, crew: true )
    member = create(:member, :crew)
    assert_equal member, Member.crewable.first, 'Crew member should be crewable, but is not.'
    refute_equal member, Member.castable.first, 'Crew member should not be castable, but is.'
  end

end
