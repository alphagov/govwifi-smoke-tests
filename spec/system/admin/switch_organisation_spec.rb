feature "Switch Organisation" do
  include_context "admin"

  it "has the expected content" do
    click_link "Switch organisation"

    expect(page).to have_xpath("//h1[text()='Switch organisation']"), content_error(page)
  end

  it "switches location" do
    click_link "Switch organisation"
    click_button "Automated Test 2"

    expect(page).to have_xpath("//div[contains(@class, 'organisation-name')]/strong[text()='Automated Test 2']"), content_error(page)
  end
end
