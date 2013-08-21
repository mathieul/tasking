FactoryGirl.define do
  factory :teammate do
    sequence :name do |n|
      "John#{n}"
    end
    sequence :initials do |n|
      "j#{n}"
    end
    color "red"
    team
  end
end
