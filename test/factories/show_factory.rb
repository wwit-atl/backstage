# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
    date { Date.today }
    name { "Show for #{date.to_s}" }

    showtime '20:00'
    calltime '18:30'

    trait :with_shift do
      skills
      after(:create) do |show|
          FactoryGirl.create(:shift,
              show: show,
              skill: show.skills.where(code: 'hm').first,
              member: Member.crewable.sample
          )
      end
    end

    trait :skills do
      after(:create) do |show|
        show.skills = [
          Skill.where(code: 'MC').first_or_create(FactoryGirl.attributes_for(:skill, code: 'MC', name: 'Master of Ceremonies', training: true)),
          Skill.where(code: 'HM').first_or_create(FactoryGirl.attributes_for(:skill, code: 'HM', name: 'House Manager', training: true, autocrew: true)),
          Skill.where(code: 'LS').first_or_create(FactoryGirl.attributes_for(:skill, code: 'LS', name: 'Lights')),
          Skill.where(code: 'SS').first_or_create(FactoryGirl.attributes_for(:skill, code: 'SS', name: 'Sound')),
          Skill.where(code: 'CS').first_or_create(FactoryGirl.attributes_for(:skill, code: 'CS', name: 'Camera')),
        ]
      end
    end

    trait :members do |count = 6|
      after(:create) do |show|
        count.times { show.members << create( :member, lastname: Faker::Name.last_name ) }
      end
    end

    trait :us do
      after(:create) do |show|
        show.group_id = Role.where(name: 'us').first.id
        show.save
      end
    end

    trait :isp do
      after(:create) do |show|
        show.group_id = Role.where(name: 'isp').first.id
        show.save
      end
    end

  end
end
