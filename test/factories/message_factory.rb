# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    subject      { Faker::Lorem.sentence }
    message      { Faker::Lorem.paragraph }
    sender       { create(:member) }

    trait :approved do
      after(:create) { |m| m.approver = create(:member) }
    end

    trait :sent do
      approved
      after(:create) { |m| m.sent_at = Time.now }
    end

    trait :delivered do
      sent
      after(:create) { |m| m.delivered_at = Time.now }
    end
  end
end
