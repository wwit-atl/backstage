require "test_helper"

class ShowTest < ActiveSupport::TestCase

  def setup
    @show = create(:show)
  end

  test 'not valid without date' do
    @show = build(:show, date: nil)
    refute @show.valid?, 'Allows save without a date'
  end

  test 'Show has many Members' do
    assert_difference('@show.members.count', 6) do
      6.times { @show.members << create( :member, lastname: Faker::Name.last_name ) }
    end
  end

  test 'Show has many Skills' do
    assert_difference('@show.skills.count', 6) do
      @show.skills = create_list( :skill, 6 )
    end
  end

  test 'Show has many Scenes' do
    assert_difference('@show.scenes.count', 5) do
      @show.scenes = create_list( :scene, 5 )
    end
  end

  test 'can select a shift by skill code' do
    @show = create(:show, :with_shift)
    assert_equal 'TS', @show.shift(:ts).skill.code
  end

  test 'Show.skills can be assigned to members' do
    @member = create(:member)
    @show   = create(:show)

    @shift = @show.shifts.create(skill: create(:skill, code: 'UN', name: 'Unique Skill'))
    @shift.member = @member

    assert_equal @member.name, @show.shift(:un).member.name
  end

end
