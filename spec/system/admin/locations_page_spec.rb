feature "Locations Page" do
  include_context "admin"

  it "has the expected content" do
    within(".leftnav") { click_link "Locations" }

    expect(page).to have_xpath "//h1[text()='Locations']"
  end

  describe "Locations", order: :defined do
    let(:location) { "Automated Test Location" }
    let(:postcode) { "N1" }

    it "adds a location" do
      within(".leftnav") { click_link "Locations" }
      click_link "Add a location"
      fill_in "location[address]", with: location
      fill_in "location[postcode]", with: postcode
      click_button "Add location"

      expect(page).to have_content "Added #{location}, #{postcode}"
    end

    it "adds an IP address" do
      within(".leftnav") { click_link "Locations" }
      find(:xpath, "//*[contains(text(), '#{location}, #{postcode}')]/ancestor::div[@class='result-row']/descendant::a[contains(text(), 'Add IP addresses')]").click
      fill_in "IP address 1", with: "8.8.8.8"
      click_button "Add IP addresses"

      expect(page).to have_content("Added 1 IP address to #{location}, #{postcode}")
    end

    it "deletes an IP address" do
      within(".leftnav") { click_link "Locations" }

      find(:xpath, "//th[normalize-space(text()) = '8.8.8.8']/following-sibling::td[2]//a").click
      click_button "Remove"

      expect(page).to have_content "Successfully removed IP address 8.8.8.8"
    end

    it "deletes a location" do
      within(".leftnav") { click_link "Locations" }

      find(:xpath, "//*[contains(text(), '#{location}, #{postcode}')]/ancestor::div[@class='result-row']/descendant::a[contains(text(), 'Remove this location')]").click
      click_button "Yes, remove this location"

      expect(page).to have_content "Successfully removed location #{location}"
    end
  end
end
