feature "Locations Page" do
  include_context "admin"

  it "has the expected content" do
    login
    visit "/ips"

    expect(page).to have_xpath "//h1[text()='Locations']"
  end

  describe "Locations", order: :defined do
    it "adds a location" do
      login
      visit "/ips"
      click_link "Add a location"
      fill_in "location[address]", with: "Automated Test Location"
      fill_in "location[postcode]", with: "N1"
      click_button "Add location"

      expect(page).to have_content "Added Automated Test Location, N1"
    end

    it "adds an IP address" do
      login
      visit "/ips"
      find(:xpath, "//*[contains(text(), 'Automated Test Location, N1')]/ancestor::caption/descendant::a[text()='Add IP addresses']").click
      fill_in "location[ips_attributes][0][address]", with: "8.8.8.8"
      click_button "Add IP addresses"

      expect(page).to have_content("Added 1 IP address to Automated Test Location, N1")
    end

    it "deletes an IP address" do
      login
      visit "/ips"
      # Would prefer to select this by IP, however the additional markup around the IP is making that difficult.
      find(:xpath, "//*[contains(text(), 'Automated Test Location, N1')]/ancestor::table/descendant::a[text()='Remove']").click
      click_button "Remove"

      expect(page).to have_content "Successfully removed IP address 8.8.8.8"
    end

    it "deletes a location" do
      login
      visit "/ips"
      find(:xpath, "//*[contains(text(), 'Automated Test Location, N1')]/ancestor::table/descendant::a[text()='Remove this location']").click
      click_button "Yes, remove this location"

      expect(page).to have_content "Successfully removed location Automated Test Location"
    end
  end
end
