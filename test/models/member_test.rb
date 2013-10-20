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

  test 'castable returns castable members' do
    member = create(:member)
    member.skills << create(:skill, :cast)
    assert_equal member, Member.castable.first
  end

  test 'does not return crew in castable' do
    create( :role, name: :volunteer, cast: false, crew: true )
    member = create(:member, :volunteer)
    refute_equal member, Member.castable.first, 'Crew role shows up in castable list'
  end

  test 'crewable returns crewable members' do
    create( :role, name: :volunteer, cast: false, crew: true )
    member = create(:member, :volunteer)
    assert_equal member, Member.crewable.first
  end

  test 'does not return cast in crewable' do
    member = create(:member)
    member.skills << create(:skill, :cast)
    refute_equal member, Member.crewable.first, 'Cast skill shows up in crewable list'
  end
end
