require 'spec_helper'

feature "Account management" do
  background do
    create(:account, email: "john@zorn.com", password: "secret0")
  end

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

  scenario "Signing in" do
    visit "/"
    click_link "Sign In"

    fill_in "Email", with: "john@zorn.com"
    fill_in "Password", with: "wrong"
    click_button "Sign In"
    page.should have_content("Email or password is invalid.")

    fill_in "Password", with: "secret0"
    click_button "Sign In"
    expect(page).to have_content("Welcome back!")
    expect(page).to have_css("li > a", text: "Sign Out")
    expect(page).not_to have_css("li > a", text: "Sign In")
  end

  scenario "Signing out" do
    visit "/sign_in"
    fill_in "Email", with: "john@zorn.com"
    fill_in "Password", with: "secret0"
    click_button "Sign In"

    click_link "Sign Out"
    expect(page).to have_content("Logged out successfully.")
    expect(page).to have_css("li > a", text: "Sign In")
  end
end
