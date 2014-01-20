# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :skill do
    name 'Sample Skill'
    code { name.split(' ').map { |n| n[0] }.join.upcase }
    category 'crew'
    training :false
    ranked :false
    autocrew :false

    trait :performance do
      name 'Stage Presence'
      category 'performance'
    end

    trait :crew do
      name 'House Manager'
      code 'HM'
      category 'crew'
      training :true
      autocrew :true
    end

    trait :cast do
      name 'Actor'
      code 'ACTOR'
      category 'cast'
    end
  end

end
