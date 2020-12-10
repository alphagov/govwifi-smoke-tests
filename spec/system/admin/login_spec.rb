feature "Admin" do
  include_context "admin"

  describe "Logging in" do
    it "logs in the user successfully" do
      login

      expect(page).to have_content "Overview"
    end
  end

  describe "Change Password" do
    def change_password(old_password, new_password)
      visit "/users/edit"
      fill_in "user[current_password]", with: old_password
      fill_in "user[password]", with: new_password
      fill_in "user[password_confirmation]", with: new_password
      click_button "Submit"
    end

    it "changes the user's password" do
      login
      change_password ENV["GW_PASS"], "Correct horse 8attery stap!e"

      expect(page).to have_content "Your account has been updated successfully."
    end

    after do
      change_password "Correct horse 8attery stap!e", ENV["GW_PASS"]
    end
  end
end
