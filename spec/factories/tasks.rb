FactoryGirl.define do
  factory :task do
    description "do something"
    hours       12
    status      "todo"
    row_order   7
    taskable_story
    team
  end
end
