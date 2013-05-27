FactoryGirl.define do
  factory :sprint do
    projected_velocity 10
    status             "planned"
    start_on           { 1.day.from_now   }
    end_on             { 15.days.from_now }
    team
  end
end
