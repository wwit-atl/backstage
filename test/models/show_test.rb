require "test_helper"

class ShowTest < ActiveSupport::TestCase

  def setup
    @show = FactoryGirl.create(:show)
  end

  test 'not valid without date' do
    @show = FactoryGirl.build(:show, date: nil)
    refute @show.valid?, 'Allows save without a date'
  end

  test 'Show has many Actors' do
    assert_difference('@show.actors.count', 6) do
      6.times { @show.actors << FactoryGirl.create( :member, lastname: Faker::Name.last_name ) }
    end
  end

  test 'Show has many Skills' do
    assert_difference('@show.skills.count', 6) do
      @show.skills = FactoryGirl.create_list( :skill, 6 )
    end
  end

  test 'Show has many Scenes' do
    assert_difference('@show.scenes.count', 5) do
      @show.scenes = FactoryGirl.create_list( :scene, 5 )
    end
  end

  test 'can select a shift by skill code' do
    @show = FactoryGirl.create(:show, :with_shift)
    assert_equal 'HM', @show.shifts.with_skill(:hm).skill.code
  end

  test 'Show can assign shifts to members' do
    @member = FactoryGirl.create(:member)
    @show   = FactoryGirl.create(:show)

    @show.shifts.create(
        member: @member,
        skill: FactoryGirl.create(:skill, code: 'UN', name: 'Unique Skill')
    )

    assert_equal @member.name, @show.shifts.with_skill(:un).member.name
  end

  test '#tickets_total sums up ticket sales' do
    Show.ticket_types.each { |type| @show.tickets[type] = 1 }
    assert_equal Show.ticket_types.count, @show.tickets_total
  end
end
