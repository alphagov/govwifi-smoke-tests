RSpec.shared_context "admin", shared_context: :metadata do
  before(:each) do
    Capybara.app_host = "http://admin.staging.wifi.service.gov.uk"
  end

  def login
    visit "/users/sign_in"
    fill_in "user[email]", with: ENV["GW_USER"]
    fill_in "user[password]", with: ENV["GW_PASS"]
    click_button "Continue"

    totp = ROTP::TOTP.new(ENV["GW_2FA_SECRET"])
    fill_in "code", with: totp.now
    click_button "Authenticate"
  end
end
