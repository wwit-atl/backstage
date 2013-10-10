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
    assert_equal Array(member), Member.castable
  end

  test 'does not return crew in castable' do
    member = create(:member)
    member.skills << create(:skill, :crew)
    refute_equal Array(member), Member.castable, 'Crew skill shows up in castable list'
  end

  test 'crewable returns crewable members' do
    member = create(:member)
    member.skills << create(:skill, :crew)
    assert_equal Array(member), Member.crewable
  end

  test 'does not return cast in crewable' do
    member = create(:member)
    member.skills << create(:skill, :cast)
    refute_equal Array(member), Member.crewable, 'Cast skill shows up in crewable list'
  end
end
