FactoryGirl.define do
  factory :shift do
    show   { create(:show) }
    skill  { create(:skill) }
    member { create(:member) }
  end
end

