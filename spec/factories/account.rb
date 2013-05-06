FactoryGirl.define do
  factory :account do
    sequence(:email) { |n| "blah-#{n}@example.com" }
  end
end