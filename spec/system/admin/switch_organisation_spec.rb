feature "Switch Organisation", :focus do
  include_context "admin"

  it "has the expected content" do
    login
    visit "/change_organisation"

    expect(page).to have_xpath "//h1[text()='Switch organisation']"
  end

  it "switches location" do
    login
    visit "/change_organisation"
    click_button "Administration of Radioactive Substances Advisory Committee"

    expect(page).to have_xpath "//div[contains(@class, 'organisation-name')]/strong[text()='Administration of Radioactive Substances Advisory Committee']"
  end
end
