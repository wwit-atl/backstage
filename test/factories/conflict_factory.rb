# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conflict do
    ignore do
      year  { Time.now.year }
      month { Time.now.month }
    end
    date { Time.local(year, month, rand * Time.days_in_month(month, year)) }
  end
end
