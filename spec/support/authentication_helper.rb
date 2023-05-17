require "rotp"
module AuthenticationHelper
  def login(username:, password:, secret:)
    visit "/"

    if page.current_path == "/users/sign_in"
      fill_in "user[email]", with: username
      fill_in "user[password]", with: password
      click_button "Continue"

      totp = ROTP::TOTP.new(secret)
      fill_in "code", with: totp.now
      click_button "Continue"
    end
  end

  def logout
    click_link "Sign out" if page.has_link?("Sign out")
  end
end
