FactoryGirl.define do
  factory :teammate do
    sequence :name do |n|
      "John#{n}"
    end
    sequence :initials do |n|
      "j#{n}"
    end
    roles ["engineer"]
    color "red"
    team
  end
end
