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

      fill_in "Enter username", with: "qwert"
      click_button "Show logs"
      expect(page).to have_content "We have no record of username \"qwert\" reaching the GovWifi service from your organisation in the last 2 weeks"
    end
  end
end
