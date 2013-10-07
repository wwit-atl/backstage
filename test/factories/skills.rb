# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :skill do
    name 'House Manager'
    code { name.split(' ').map { |n| n[0] }.join.upcase }
    category 'Shift'

    trait :performance do
      name 'Stage Presence'
      category 'Performance'
    end
  end

end
