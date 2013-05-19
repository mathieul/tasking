FactoryGirl.define do
  factory :story do
    description "as a tester I can test so I know it works"
    row_order   7
    points      5
    team
  end
end
