FactoryGirl.define do
  factory :sprint do
    ignore do
      sprints_count 3
    end

    projected_velocity 10
    status             "planned"
    start_on           { 1.day.from_now   }
    end_on             { 15.days.from_now }
    team

    after :build do |sprint, evaluator|
      evaluator.sprints_count.times do
        sprint.stories << build(:story, team: sprint.team)
      end
    end
  end
end
