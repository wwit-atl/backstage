# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conflict do
    year  { Time.now.year }
    month { Time.now.month }
    day   { Time.now.day }
  end
end
