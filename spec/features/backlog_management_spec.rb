require 'spec_helper'

feature "Backlog management" do
  include SignInSpecHelpers

  background do
    create(:account, email: "serge@gainsbourg.com", password: "auxarmesetc...").activate!
  end

  scenario "Create story" do
    sign_in("serge@gainsbourg.com", password: "auxarmesetc...")
    click_link "Backlog"

    [
      "Tech Lead", "PM", "Id", "Business Driver", "Sort", "User Story",
      "Story Points", "Spec"
    ].each do |column|
      expect(page).to have_content column
    end
  end
end
