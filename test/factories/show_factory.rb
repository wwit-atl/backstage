# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
    date '2013-10-02'
    showtime '20:00'
    calltime '18:30'
  end
end
