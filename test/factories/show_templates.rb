# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show_template do
    name "Test Show"
    dow 0
    calltime "2000-01-01 18:30:00"
    showtime "2000-01-01 20:00:00"
  end
end
