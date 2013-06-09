require 'spec_helper'

feature "Backlog management" do
  include SignInSpecHelpers

  background do
    team = create(:team)
    create(:account, email: "serge@gainsbourg.com", password: "auxarmesetc...", team: team).activate!
    create(:teammate, name: "Ari", roles: ["tech_lead"], team: team)
    create(:teammate, name: "Sophie", roles: ["product_manager"], team: team)
  end

  scenario "Create story", js: true do
    sign_in "serge@gainsbourg.com", password: "auxarmesetc..."
    click_link "Backlog"
    expect(page).to have_content("There are no stories in the backlog yet.")
    click_link "Create first story"
    # expect(page).to have_content("New user story")

    fill_in "Description", with: "As a user I can do something so I benefit from it"
    select "Ari", from: "Tech lead"
    select "Sophie", from: "Product manager"
    fill_in "Business driver", with: "usability"
    fill_in "Spec link", with: "http://www.google.com"
    click_on "Create story"
    within "tbody.table tr:nth(1)" do
      expect(page).to have_css("> td:nth(2)", text: "Ari")
      expect(page).to have_css("> td:nth(3)", text: "Sophie")
      expect(page).to have_css("> td:nth(4)", text: "usability")
      expect(page).to have_css("> td:nth(5)", text: "As a user I can do something so I benefit from it")
      expect(page).to have_css("> td:nth(6)", text: "3")
      expect(page).to have_css("> td:nth(7)", text: "http://www.google.com")
    end
  end
end
