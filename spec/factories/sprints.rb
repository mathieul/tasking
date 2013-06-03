FactoryGirl.define do
  factory :sprint do
    ignore do
      stories_count 3
    end

    projected_velocity 10
    status             "planned"
    start_on           { 1.day.from_now   }
    end_on             { 15.days.from_now }
    team

    after :create do |sprint, evaluator|
      evaluator.stories_count.times do
        story = create(:story, team: sprint.team)
        create(:taskable_story, sprint: sprint, story: story, team: sprint.team)
      end
    end
  end
end
