# frozen_string_literal: true

module AuthenticationHelpers
  def login(username:, password:, totp:)
    visit "/"

    if page.current_path == "/users/sign_in"
      fill_in "user[email]", with: username
      fill_in "user[password]", with: password
      click_button "Continue"

      totp = ROTP::TOTP.new(totp)
      fill_in "code", with: totp.now
      click_button "Continue"
    end
  end

  def logout
    click_link "Sign out"
  end
end
