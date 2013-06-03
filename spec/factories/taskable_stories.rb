FactoryGirl.define do
  factory :taskable_story do
    status    "scheduled"
    row_order 1
    story
    sprint
    team
  end
end
