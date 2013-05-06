require 'spec_helper'

feature "Account management" do
  scenario "Signing up" do
    visit "/"
    click_link "Sign Up"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "123"
    click_button "Sign Up"
    page.should have_content("Please review the problems below:")
    page.should have_content("is too short (minimum is 6 characters)")

    fill_in "Password", with: "verysecret"
    click_button "Sign Up"
    current_path.should == "/"
    page.should have_content("Thank you for signing up!")
  end
end
