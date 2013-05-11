module SignInSpecHelpers
  def sign_in(email, password: "secret01")
    visit "/sign_in"
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign In"
    expect(page).to have_content "Welcome back!"
  end
end
