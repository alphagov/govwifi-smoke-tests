feature "Locations Page" do
  include_context "admin"

  it "has the expected content" do
    within(".leftnav") { click_link "Locations" }

    expect(page).to have_xpath "//h1[text()='Locations']"
  end

  describe "Locations", order: :defined do
    before(:all) do
      visit "/overview"
      @locations_count = find(:xpath, "//p[@id='locations-count']")["innerText"].to_i
      @ips_count = find(:xpath, "//p[@id='ips-count']")["innerText"].to_i
    end

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
      fill_in "location[ips_attributes][0][address]", with: "8.8.8.8"
      click_button "Add IP addresses"

      expect(page).to have_content("Added 1 IP address to #{location}, #{postcode}")
    end

    it "shows the expected information on overview page" do
      visit "/overview"

      expect(find(:xpath, "//p[@id='locations-count']")["innerText"].to_i).to be(@locations_count + 1)
      expect(find(:xpath, "//p[@id='ips-count']")["innerText"].to_i).to be(@ips_count + 1)
    end

    it "deletes an IP address" do
      within(".leftnav") { click_link "Locations" }

      # Would prefer to select this by IP, however the additional markup around the IP is making that difficult.
      find(:xpath, "//*[contains(text(), '#{location}, #{postcode}')]/ancestor::div[@class='result-row']/descendant::a[contains(text(), 'Remove')]").click
      click_button "Remove"

      expect(page).to have_content "Successfully removed IP address 8.8.8.8"
    end

    it "deletes a location" do
      within(".leftnav") { click_link "Locations" }

      find(:xpath, "//*[contains(text(), '#{location}, #{postcode}')]/ancestor::div[@class='result-row']/descendant::a[contains(text(), 'Remove this location')]").click
      click_button "Yes, remove this location"

      expect(page).to have_content "Successfully removed location #{location}"
    end

    it "shows the expected information on overview page" do
      visit "/overview"

      expect(find(:xpath, "//p[@id='locations-count']")["innerText"].to_i).to be(@locations_count)
      expect(find(:xpath, "//p[@id='ips-count']")["innerText"].to_i).to be(@ips_count)
    end
  end
end
