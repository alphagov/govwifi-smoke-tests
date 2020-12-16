feature "Logs Page" do
  include_context "admin"

  it "has the expected content" do
    login
    visit "/logs/search/new"
    expect(page).to have_content "Logs are kept for recent authentication requests made to the GovWifi service."
  end

  describe "Search" do
    it "shows the expected results page" do
      login
      visit "/logs/search/new"
      choose "Username", visible: false # Styling means the underlying radio is hidden.

      # This isn't working. I don't know why.
      # It works fine in normal mode, but fails in headless.
      # It's just clicking a button, like any other button.
      # click_button "Go to search"

      # This is the workaround:
      page.execute_script("$('input[value=\"Go to search\"]').click()")

      fill_in "logs_search_search_term", with: "qwert"
      click_button "Show logs"

      expect(page).to have_content "The username \"qwert\" is not reaching the GovWifi service"
    end
  end
end
