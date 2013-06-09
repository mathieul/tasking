require 'spec_helper'
require 'timecop'

feature "Sprint management" do
  include SignInSpecHelpers

  given(:for_a_bit) { 0.25 }
  given(:team)      { create(:team) }
  given(:story1)    { create(:story, description: "authentication", points: 5, team: team) }
  given(:story2)    { create(:story, description: "send email", points: 13, team: team) }

  background do
    create(:account, email: "serge@gainsbourg.com", password: "auxarmesetc...", team: team).activate!
    create(:teammate, name: "Serge", roles: ["teammate"], color: "red", team: team)
    create(:teammate, name: "Alain", roles: ["teammate"], color: "purple", team: team)
    create(:story)
  end

  scenario "Create tasks", js: true do
    Timecop.travel Time.local(2012, 4, 12, 7, 0, 0)

    sprint = team.sprints.create! start_on:           "2012-04-12",
                                  end_on:             "2012-04-26",
                                  projected_velocity: 18,
                                  story_ids: [story1.id, story2.id]

    sign_in "serge@gainsbourg.com", password: "auxarmesetc..."
    click_link "Sprints"
    click_link "Current Sprint"
    expect(page).to have_content("Sprint Tasking")
    raise "WIP"
    # binding.pry
    Timecop.return
  end
end
