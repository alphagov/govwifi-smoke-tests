feature "Team Page" do
  include_context "admin"

  it "has the expected content" do
    within(".leftnav") { click_link "Team members" }
    expect(page).to have_xpath "//h1[text()='Team members']"
  end

  describe "Managing Team members", order: :defined do
    let(:test_email) { ENV["GW_USER"].sub("@", "+automated-test@") }

    it "adds a team member" do
      within(".leftnav") { click_link "Team members" }
      click_link "Invite a team member"
      fill_in "user[email]", with: test_email
      click_button "Send invitation email"

      expect(page).to have_content "#{test_email} has been invited to join"
    end

    it "removes a team member" do
      within(".leftnav") { click_link "Team members" }

      find(:xpath, "//*[contains(text(), '#{test_email}')]/ancestor::dd/descendant::a[contains(text(), 'Edit permissions')]").click
      click_link "Remove user from GovWifi admin"
      click_button "Yes, remove this team member"

      expect(page).to have_content "Team member has been removed"
    end
  end
end
