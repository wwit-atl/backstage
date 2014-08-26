require "test_helper"

class SkillTest < ActiveSupport::TestCase

  test 'not valid without code' do
    skill = FactoryGirl.build(:skill, code: nil, name: 'Test Skill')
    refute skill.valid?, 'Allows save without a code'
  end

  test 'not valid without name' do
    skill = FactoryGirl.build(:skill, code: 'TS', name: nil)
    refute skill.valid?, 'Allows save without a name'
  end

  test 'sorts skills by code' do
    [ 'Alpha Alpha', 'Alpha Beta', 'Alpha Charlie',
      'Beta Delta', 'Beta Echo', 'Beta Foxtrot',
      'Charlie Golf', 'Charlie Hotel', 'Charlie Indigo',
    ].shuffle.each { |name| FactoryGirl.create(:skill, name: name) }
    assert_not_equal %w( AA AB AC BD BE BF CG CH CI ), Skill.all.map(&:code)
    assert_equal %w( AA AB AC BD BE BF CG CH CI ), Skill.by_code.map(&:code)
  end
end
