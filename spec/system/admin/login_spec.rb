feature "Admin" do
  describe "Logging in" do
    it "logs in the user successfully" do
      visit "/users/sign_in"

      fill_in "user[email]", with: ENV["GW_USER"]
      fill_in "user[password]", with: ENV["GW_PASS"]
      click_button "Continue"

      totp = ROTP::TOTP.new(ENV["GW_2FA_SECRET"])
      fill_in "code", with: totp.now
      click_button "Authenticate"

      expect(page).to have_content "Overview"
    end
  end

  describe "Change Password", :with_login do
    it "changes the user's password" do
      visit "/users/edit"
      fill_in "user[current_password]", with: ENV["GW_PASS"]
      fill_in "user[password]", with: "Correct horse 8attery stap!e"
      fill_in "user[password_confirmation]", with: "Correct horse 8attery stap!e"
      click_button "Submit"

      expect(page).to have_content "Your account has been updated successfully."
    end

    after do
      visit "/users/edit"
      fill_in "user[current_password]", with: "Correct horse 8attery stap!e"
      fill_in "user[password]", with: ENV["GW_PASS"]
      fill_in "user[password_confirmation]", with: ENV["GW_PASS"]
      click_button "Submit"
    end
  end
end
