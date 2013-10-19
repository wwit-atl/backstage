# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conflict do
    year  { Time.now.year }
    month { Time.now.month }
    day   { rand(1..Time.days_in_month(month)) }
  end
end
