FactoryGirl.define do
  factory :account do
    sequence :email do |n|
      "blah-#{n}@example.com"
    end
    password 'secret'
    team
  end
end
