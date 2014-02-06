# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    subject "MyString"
    message "MyText"
    sent_at "2014-02-03 20:47:20"
    sent_by 1
    approved_by 1
  end
end
