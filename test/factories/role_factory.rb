FactoryGirl.define do

  factory :role do
    name     :tr
    title    'Test Role'
    description 'This is a test role'
    cast     false
    crew     false
    schedule false

    trait :cast do
      after(:create) { |r| r.cast = true }
    end

    trait :crew do
      after(:create) { |r| r.crew = true }
    end
  end

end
