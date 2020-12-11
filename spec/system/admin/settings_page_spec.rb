feature "Settings Page" do
  include_context "admin"

  describe "Change Password", order: :defined do
    let(:new_password) { "Correct horse 8attery stap!e" }

    def change_password(old_password, new_password)
      visit "/users/edit"
      fill_in "user[current_password]", with: old_password
      fill_in "user[password]", with: new_password
      fill_in "user[password_confirmation]", with: new_password
      click_button "Submit"
    end

    it "changes the user's password" do
      login
      change_password ENV["GW_PASS"], new_password

      expect(page).to have_content "Your account has been updated successfully."
    end

    it "logs in with the new password" do
      login(new_password)

      expect(page).to have_content "Overview"

      change_password new_password, ENV["GW_PASS"]
    end
  end

  describe "GovWifi servers", :focus do
    it "shows three london servers" do
      login
      visit "/setup_instructions"
      expect(page).to have_css("#london-radius-ips .ip-address", count: 3)
    end

    it "shows three dublin servers" do
      login
      visit "/setup_instructions"
      expect(page).to have_css("#dublin-radius-ips .ip-address", count: 3)
    end
  end
end
