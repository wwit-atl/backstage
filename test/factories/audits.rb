# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :audit do
    ident 'TestIdent'
    message 'Test message'
    member nil
  end
end
