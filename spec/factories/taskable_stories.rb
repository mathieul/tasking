FactoryGirl.define do
  factory :taskable_story do
    status "scheduled"
    story
    sprint
    team
  end
end
