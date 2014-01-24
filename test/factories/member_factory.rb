FactoryGirl.define do

  factory :phone do
    ntype  { %w[ Home Work Mobile Other ].sample }
    number { 10.times.map{ Random.rand(10) }.join }
    member
  end

  factory :member do
    firstname             { Faker::Name.first_name }
    lastname              { Faker::Name.last_name  }
    sex                   { [ :M, :F ].sample      }
    dob                   { Time.at(rand * (Time.now - 40.years.ago).to_f).to_date.to_formatted_s(:db) }
    password              'password'
    password_confirmation 'password'
    email                 { "#{firstname[0]}#{lastname}".downcase + '@example.com' }

    after(:create) { |m| m.confirm! if m.respond_to?('confirm!') }

    trait :with_phones do
      after(:create) do |member|
        FactoryGirl.create_list(:phone, 2, member: member)
      end
    end

    trait :with_conflicts do
      after(:create) do |member|
        3.times { member.conflicts << create(:conflict) }
      end
    end

    trait :admin do
      firstname 'admin'
      lastname  'person'
      after(:create) { |member| member.add_role :admin }
    end

    trait :cast do
      after(:create) { |m| m.add_role :cast }
    end

    trait :crew do
      after(:create) { |m| m.add_role :crew }
    end

    trait :ms do
      cast
      after(:create) { |m| m.add_role :ms }
    end

    trait :us do
      cast
      crew
      after(:create) { |m| m.add_role :us }
    end

    trait :isp do
      cast
      crew
      after(:create) { |m| m.add_role :isp }
    end

    trait :volunteer do
      crew
      after(:create) { |m| m.add_role :volunteer }
    end

    trait :train_hm do
      crew
      after(:create) { |m| m.skills << Skill.with_code(:hm) }
    end

  end
end
