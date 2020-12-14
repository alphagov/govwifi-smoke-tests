RSpec.shared_context "admin", shared_context: :metadata do
  before(:all) do
    unless ENV["GW_USER"] && ENV["GW_PASS"] && ENV["GW_2FA_SECRET"]
      abort "\e[31mMust define GW_USER, GW_PASS, and GW_2FA_SECRET\e[0m"
    end
  end

  before(:each) do
    Capybara.app_host = "http://admin.staging.wifi.service.gov.uk"
  end

  def login(password = ENV["GW_PASS"])
    visit "/users/sign_in"
    fill_in "user[email]", with: ENV["GW_USER"]
    fill_in "user[password]", with: password
    click_button "Continue"

    totp = ROTP::TOTP.new(ENV["GW_2FA_SECRET"])
    fill_in "code", with: totp.now
    click_button "Authenticate"
  end

  def logout
    click_link "Sign out"
  end
end
