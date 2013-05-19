FactoryGirl.define do
  factory :teammate do
    sequence :name do |n|
      "John#{n}"
    end
    roles ["engineer"]
    team
  end
end
