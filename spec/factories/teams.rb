FactoryGirl.define do
  factory :team do
    sequence :name do |n|
      "My Team ##{n}"
    end
    projected_velocity  7
  end
end
