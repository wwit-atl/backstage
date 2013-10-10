# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :skill do
    name 'Sample Skill'
    code { name.split(' ').map { |n| n[0] }.join.upcase }

    trait :performance do
      name 'Stage Presence'
      category 'performance'
    end

    trait :crew do
      name 'House Manager'
      code 'HM'
      category 'crew'
    end

    trait :cast do
      name 'Actor'
      code 'CAST'
      category 'cast'
    end
  end

end
