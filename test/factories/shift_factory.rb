FactoryGirl.define do
  factory :shift do
    show   { create(:show) }
    skill  { create(:skill) }
    member { create(:member) }
    hidden :false
    training :false
  end
end

