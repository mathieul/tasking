require 'spec_helper'

feature "Account management" do
  given(:for_a_bit) { 0.25 }

  background do
    create(:account, email: "john@zorn.com", password: "secret0").activate!
  end

  scenario "Signing up", js: true do
    visit "/"
    click_link "Sign Up"

    fill_in "Email",    with: "user@example.com"
    fill_in "Password", with: "123"
    fill_in "Team name", with: "X"
    click_button "Sign Up"
    expect(page).to have_content "Please review the problems below:"
    expect(page).to have_content "is too short (minimum is 6 characters)"

    fill_in "Team name", with: "Ze Team"
    fill_in "Password",  with: "verysecret"
    click_button "Sign Up"
    expect(page).to have_content "Thank you for signing up!"
    expect(current_path).to eq("/stories")
    account = Account.find_by(email: "user@example.com")
    expect(account).not_to be_nil
    expect(account.team.name).to eq("Ze Team")
    expect(account).to be_admin
  end

  scenario "Guessing team name when signing up", js: true do
    visit "/"
    click_link "Sign Up"
    fill_in "Email",    with: "mathieu@caring.com"
    fill_in "Password", with: "whatever"
    expect(find_field("Team name").value).to eq("Caring")
  end

  scenario "Signing in", js: true do
    visit "/"
    click_link "Sign In"

    fill_in "Email",    with: "john@zorn.com"
    fill_in "Password", with: "wrong"
    click_button "Sign In"
    expect(page).to have_content "Email or password is invalid."

    fill_in "Password", with: "secret0"
    click_button "Sign In"
    expect(page).to have_content "Welcome back!"
    click_on "john@zorn.com"
    expect(page).to have_css "li > a", text: "Sign Out"
    expect(page).not_to have_css "li > a", text: "Sign In"
  end

  scenario "Signing out", js: true do
    visit "/sign_in"
    fill_in "Email",    with: "john@zorn.com"
    fill_in "Password", with: "secret0"
    click_button "Sign In"

    click_on "john@zorn.com"
    click_link "Sign Out"
    expect(page).to have_content "Logged out successfully."
    expect(page).to have_css "li > a", text: "Sign In"
  end

  scenario "Forgotten password", js: true do
    clear_emails
    visit "/"
    click_link "Sign In"

    click_link "forgotten password?"
    fill_in "Email", with: "john@zorn.com"
    click_button "Reset Password"
    expect(page).to have_content "Email sent with password reset instructions."

    open_email "john@zorn.com"
    current_email.click_link "Reset my password"
    expect(current_email).to be_present
    fill_in "New Password", with: "verysecret1"
    click_button "Update Password"
    expect(page).to have_content "Password has been reset!"
    click_on "john@zorn.com"
    click_link "Sign Out"

    click_link "Sign In" and sleep for_a_bit
    fill_in "Email",    with: "john@zorn.com"
    fill_in "Password", with: "verysecret1"
    click_button "Sign In"
    expect(page).to have_content "Welcome back!"
  end

  scenario "Confirm account", js: true do
    clear_emails
    visit "/sign_up"
    fill_in "Team name", with: "Ze Team"
    fill_in "Email",     with: "user@example.com"
    fill_in "Password",  with: "verysecret"
    click_button "Sign Up"
    click_on "user@example.com"
    click_link "Sign Out"

    click_link "Sign In" and sleep for_a_bit
    fill_in "Email",    with: "user@example.com"
    fill_in "Password", with: "verysecret"
    click_button "Sign In"
    expect(page).to have_content "This account hasn't yet been confirmed. Please follow instructions emailed."

    open_email "user@example.com"
    expect(current_email).to be_present
    current_email.click_link "Confirm my account"
    expect(page).to have_content "Thank you for confirming your account!"

    visit "/"
    click_link "Sign In"
    fill_in "Email",    with: "user@example.com"
    fill_in "Password", with: "verysecret"
    click_button "Sign In"
    expect(page).to have_content "Welcome back!"
  end
end
