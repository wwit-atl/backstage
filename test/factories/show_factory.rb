# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
    date '2013-10-02'
    showtime '20:00'
    calltime '18:30'

    trait :with_shift do |skill|
      after(:create) do |show|
          FactoryGirl.create(:shift,
              show: show,
              skill: FactoryGirl.create(:skill, code: 'TS', name: 'Test Skill'),
              member: FactoryGirl.create(:member),
          )
      end
    end

    trait :all_skills do
      after(:create) do |show|
        show.skills = [
          FactoryGirl.create(:skill, code: 'MC', name: 'Master of Ceremonies'),
          FactoryGirl.create(:skill, code: 'HM', name: 'House Manager'),
          FactoryGirl.create(:skill, code: 'LB', name: 'Lights'),
          FactoryGirl.create(:skill, code: 'SB', name: 'Sound'),
          FactoryGirl.create(:skill, code: 'CS', name: 'Camera'),
        ]
      end
    end

    trait :members do |count = 6|
      after(:create) do |show|
        count.times { show.members << create( :member, lastname: Faker::Name.last_name ) }
      end
    end


  end
end
