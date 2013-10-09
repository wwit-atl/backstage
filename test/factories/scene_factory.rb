FactoryGirl.define do
  factory :scene do
    sequence(:position)
    suggestion 'Who, What, Where'
  end
end

