# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skill do
    name 'Sample Skill'
    description 'Sample Skill Description'
    code { name.split(' ').map { |n| n[0] }.join.upcase }
    training false
    autocrew false
    limits   false

    trait :crew do
      name 'House Manager'
      code 'HM'
      training true
      autocrew true
    end
  end
end
