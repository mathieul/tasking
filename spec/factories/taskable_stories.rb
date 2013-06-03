FactoryGirl.define do
  factory :taskable_story do
    row_order 1
    story
    sprint
    team
  end
end
