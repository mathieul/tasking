FactoryGirl.define do
  factory :account do
    sequence :email do |n|
      "blah-#{n}@example.com"
    end
    password 'secret'
    password_confirmation { password }
    team
  end
end
