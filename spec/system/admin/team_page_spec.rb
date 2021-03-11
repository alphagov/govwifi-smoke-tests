feature "Team Page" do
  include_context "admin"

  it "has the expected content" do
    within(".leftnav") { click_link "Team members" }
    expect(page).to have_xpath("//h1[text()='Team members']"), content_error(page)
  end

  describe "Managing Team members", order: :defined do
    before(:all) do
      visit "/overview"
      @team_members_count = find(:xpath, "//h1[@id='team-members-count']")["innerText"].to_i
    end

    let(:test_email) { ENV["GW_USER"].sub("@", "+automated-test@") }

    it "adds a team member" do
      within(".leftnav") { click_link "Team members" }
      click_link "Invite team member"
      fill_in "user[email]", with: test_email
      click_button "Send invitation email"

      expect(page).to have_content("#{test_email} has been invited to join"), content_error(page)
    end

    it "shows the expected information on overview page" do
      visit "/overview"
      expect(find(:xpath, "//h1[@id='team-members-count']")["innerText"].to_i).to be(@team_members_count + 1), content_error(page)
    end

    it "removes a team member" do
      within(".leftnav") { click_link "Team members" }

      find(:xpath, "//*[contains(text(), '#{test_email} (invited)')]/ancestor::li/descendant::a[contains(text(), 'Edit permissions')]").click
      click_link "Remove user from GovWifi admin"
      click_button "Yes, remove this team member"

      expect(page).to have_content("Team member has been removed"), content_error(page)
    end

    it "shows the expected information on overview page" do
      visit "/overview"
      expect(find(:xpath, "//h1[@id='team-members-count']")["innerText"].to_i).to be(@team_members_count), content_error(page)
    end
  end
end
