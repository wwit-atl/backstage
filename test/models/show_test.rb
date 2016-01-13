require "test_helper"

class ShowTest < ActiveSupport::TestCase

  def setup
    @show = FactoryGirl.create(:show)
    @types = Show.ticket_types || []
    @type = @types.first || :foo
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

  test 'capacity returns the default capacity when not set' do
    show = FactoryGirl.create(:show, capacity: nil)
    assert_equal Konfig.default_show_capacity, show.capacity
  end

  test '#tickets_total return 0 when no tickets sold' do
    @show.tickets = {}
    assert_equal 0, @show.tickets_total

    @types.each { |type| @show.tickets[type] = 0 }
    assert_equal 0, @show.tickets_total
  end

  # Test edge case, where tickets are nil (e.g. a new record)
  test '#tickets_total returns 0 when tickets is nil' do
    @show.tickets = nil
    assert_equal 0, @show.tickets_total
  end

  test '#tickets_total sums up ticket sales' do
    @show.tickets = {}
    @types.each { |type| @show.tickets[type] = 1 }
    assert_equal @types.count, @show.tickets_total
  end

  test '#sold_out? returns false when tickets_total < capacity' do
    @show.capacity = 5
    @show.tickets = { @type => @show.capacity - 1 }
    refute @show.sold_out?, "#sold_out? should be false, but it's true"
  end

  test '#sold_out? returns true when tickets_total >= capacity' do
    @show.capacity = 5
    @show.tickets = { @type => @show.capacity }
    assert @show.sold_out?, "#sold_out? should be true, but it's false"
  end

  test '#sold_out? returns false when tickets is nil' do
    @show.capacity = 5
    @show.tickets = nil
    refute @show.sold_out?, "#sold_out? should be false, but it's true"
  end

  test 'responds to valid ticket_types' do
    @types.each do |type|
      assert_respond_to @show, type
    end
    assert_not_respond_to @show, :flimflam
  end

  test 'returns a valid ticket count using accessor' do
    @show.tickets = { @type => 13 }
    assert_equal @show.send(@type), 13
  end

end
