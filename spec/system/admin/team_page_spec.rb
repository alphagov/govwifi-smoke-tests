feature "Team Page" do
  include_context "admin"

  it "has the expected content" do
    login
    visit "/memberships"
    expect(page).to have_content "Team members"
  end

  describe "Managing Team members", order: :defined do
    let(:test_email) { ENV["GW_USER"].sub("@", "+automated-test@") }

    it "successfully adds a team member" do
      login
      visit "/memberships"
      click_link "Invite team member"
      fill_in "user[email]", with: test_email
      click_button "Send invitation email"

      expect(page).to have_content "#{test_email} has been invited to join Government Digital Service"
    end

    it "successfully removes a team member" do
      login
      visit "/memberships"
      find(:xpath, "//*[contains(text(), '#{test_email} (invited)')]/ancestor::li/descendant::a[contains(text(), 'Edit permissions')]").click
      click_link "Remove user from GovWifi admin"
      click_button "Yes, remove this team member"

      expect(page).to have_content "Team member has been removed"
    end
  end
end
