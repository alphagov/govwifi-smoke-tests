require "capybara/rspec"
require "rotp"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Capybara::DSL

  config.before(:each, with_login: true) do
    visit "/users/sign_in"
    fill_in "user[email]", with: ENV["GW_USER"]
    fill_in "user[password]", with: ENV["GW_PASS"]
    click_button "Continue"
    totp = ROTP::TOTP.new(ENV["GW_2FA_SECRET"])
    fill_in "code", with: totp.now
    click_button "Authenticate"
  end
end

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium_headless
  Capybara.app_host = "http://admin.staging.wifi.service.gov.uk"
end
