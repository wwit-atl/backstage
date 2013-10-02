FactoryGirl.define do

  factory :phone do
    ntype  { %w[ Home Work Mobile Other ].sample }
    number { 10.times.map{ Random.rand(10) }.join }
    member
  end

  factory :member do
    firstname             'John'
    lastname              'Doe'
    password              'password'
    password_confirmation 'password'
    email                 { "#{firstname[0]}#{lastname}".downcase + '@example.com' }

    factory :member_with_phones do
      ignore { phone_count 2 }
      after(:create) do |member, evaluator|
        FactoryGirl.create_list(:phone, evaluator.phone_count, member: member)
      end
    end
  end

  factory :admin, :parent => :member do
    firstname 'admin'
    lastname  'person'
    after(:create) do |member|
      member.add_role :admin
    end
  end

end
