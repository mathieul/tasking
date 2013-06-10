require 'spec_helper'
require 'timecop'

feature "Sprint management" do
  include SignInSpecHelpers

  given(:for_a_bit) { 0.5 }
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
    # check tasks table content
    within "table.tasks tbody" do
      within "tr:nth-child(1)" do
        expect(page).to have_css("td:nth-child(2)", text: "authentication")
        expect(page).to have_css("td:nth-child(3)", text: "5")
      end
      within "table.tasks tr:nth-child(2)" do
        expect(page).to have_css("td:nth-child(2)", text: "send email")
        expect(page).to have_css("td:nth-child(3)", text: "13")
      end
    end
    # create todo task
    task = find('table.tasks tbody tr:nth-child(1) td.task[data-status="todo"]')
    task.hover
    task.find(".add-task").click
    task.find(".task-input").set("write tests")
    find("body").click and sleep for_a_bit
    first_todo_task = all('table.tasks tbody tr:nth-child(1) td.task[data-status="todo"]').first.text
    expect(first_todo_task).to eq("write tests 0")
    Timecop.return
  end
end
