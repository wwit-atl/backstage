# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skill do
    name 'Sample Skill'
    code { name.split(' ').map { |n| n[0] }.join.upcase }
    training :false
    autocrew :false
    limits   :false

    trait :crew do
      name 'House Manager'
      code 'HM'
      training :true
      autocrew :true
      limits   :false
    end
  end
end
