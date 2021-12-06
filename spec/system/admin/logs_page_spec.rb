feature "Logs Page" do
  include_context "admin"

  it "has the expected content" do
    within(".leftnav") { click_link "Logs" }
    expect(page).to have_content "Logs are kept for recent authentication requests made to the GovWifi service."
  end

  describe "Search" do
    it "shows the expected results page" do
      within(".leftnav") { click_link "Logs" }
      choose "Username", visible: false # Styling means the underlying radio is hidden.

      click_button "Go to search"

      fill_in "logs_search_search_term", with: "qwert"
      click_button "Show logs"
      expect(page).to have_content "The username \"qwert\" is not reaching the GovWifi service"
    end
  end
end
