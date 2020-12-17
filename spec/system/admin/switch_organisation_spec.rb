feature "Switch Organisation" do
  include_context "admin"

  it "has the expected content" do
    click_link "Switch organisation"

    expect(page).to have_xpath "//h1[text()='Switch organisation']"
  end

  it "switches location" do
    click_link "Switch organisation"
    click_button "Administration of Radioactive Substances Advisory Committee"

    expect(page).to have_xpath "//div[contains(@class, 'organisation-name')]/strong[text()='Administration of Radioactive Substances Advisory Committee']"
  end
end
