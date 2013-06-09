require 'spec_helper'
require 'timecop'

feature "Backlog management" do
  include SignInSpecHelpers

  given(:team)      { create(:team, projected_velocity: 7) }
  given(:for_a_bit) { 0.25 }

  background do
    create(:account, email: "serge@gainsbourg.com", password: "auxarmesetc...", team: team).activate!
    create(:teammate, name: "Ari", roles: ["tech_lead"], team: team)
    create(:teammate, name: "Sophie", roles: ["product_manager"], team: team)
  end

  scenario "Create story", js: true do
    sign_in "serge@gainsbourg.com", password: "auxarmesetc..."
    click_link "Backlog"
    expect(page).to have_content("There are no stories in the backlog yet.")
    sleep for_a_bit and click_on "Create first story"
    expect(page).to have_content("New user story")

    fill_in "Description", with: "As a user I can do something so I benefit from it"
    click_on "8"
    select "Ari", from: "Tech lead"
    select "Sophie", from: "Product manager"
    fill_in "Business driver", with: "usability"
    fill_in "Spec link", with: "http://www.google.com"
    click_on "Create story" and sleep for_a_bit
    within "tbody.table tr:nth-child(2)" do
      expect(page).to have_css("td:nth-child(2)", text: "Ari")
      expect(page).to have_css("td:nth-child(3)", text: "Sophie")
      expect(page).to have_css("td:nth-child(4)", text: "usability")
      expect(page).to have_css("td:nth-child(5)", text: "As a user I can do something so I benefit from it")
      expect(page).to have_css("td:nth-child(6)", text: "8")
      expect(page).to have_css("td:nth-child(7)", text: "http://www.google.com")
    end
  end

  scenario "Edit story", js: true do
    create(:story, description: "as a user I can sign up", points: 8, row_order: 1, team: team)
    create(:story, description: "as a user I can sign in", points: 5, row_order: 2, team: team)

    sign_in "serge@gainsbourg.com", password: "auxarmesetc..."
    click_link "Backlog"
    find("tbody.table tr:nth-child(2)").hover and sleep for_a_bit
    find("tbody.table tr:nth-child(2) a > i.icon-pencil").click
    expect(page).to have_content("Edit user story")
    fill_in "Description", with: "user sign up"
    select "Ari", from: "Tech lead"
    select "Sophie", from: "Product manager"
    click_button "Update story"
    within "tbody.table tr:nth-child(2)" do
      expect(page).to have_css("td:nth-child(2)", text: "Ari")
      expect(page).to have_css("td:nth-child(3)", text: "Sophie")
      expect(page).to have_css("td:nth-child(5)", text: "user sign up")
    end
  end

  scenario "Create New Sprint", js: true do
    create(:story, description: "as a user I can sign up", points: 8, row_order: 1, team: team)
    create(:story, description: "as a user I can sign in", points: 5, row_order: 2, team: team)

    Timecop.travel Time.local(2013, 3, 9, 14, 0, 0)
    sign_in "serge@gainsbourg.com", password: "auxarmesetc..."
    click_link "Backlog"
    fill_in "velocity", with: 15
    within "tbody.table tr:nth-child(3)" do
      expect(page).to have_css("td:nth-child(2)",
                               text: "This is where we wish the line to be... New Sprint")
      expect(page).to have_css("td:nth-child(3)", text: "13") # 8 + 5 points
    end
    click_on "New Sprint"
    expect(page).to have_content("New Sprint")
    expect(find_field("Start on").value).to eq("2013-03-10")
    expect(find_field("End on").value).to eq("2013-03-24")
    expect(find("#sprint_projected_velocity")["disabled"]).to eq("disabled")
    expect(find("#sprint_projected_velocity").value).to eq("15")

    click_button "Create Sprint"
    click_button "Create Sprint"  # TODO: figure out why we need to click twice here...
    expect(page).to have_content("Sprint Tasking")
    Timecop.return
  end
end
