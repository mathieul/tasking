# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teammate do
    name "John"
    roles ["engineer"]
    account
  end
end
