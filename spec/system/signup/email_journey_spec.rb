require_relative "../../../lib/notify_email"
require_relative "../../../lib/eapol_test"
require_relative "../../../lib/services"

feature "Email Journey" do
  include NotifyEmail
  include EapolTest

  let(:signup_address) { "signup@#{ENV['SUBDOMAIN']}.service.gov.uk" }
  let(:notify_address) do
    notify_field = ENV["SUBDOMAIN"] == "wifi" ? "govwifi" : "govwifistaging"
    "#{notify_field}@notifications.service.gov.uk"
  end
  let(:client_address) { from_address }

  before :all do
    remove_user(user: from_address)
  end
  it "has removed the user" do
    using_session("Admin") do
      login(username: ENV["GW_SUPER_ADMIN_USER"], password: ENV["GW_SUPER_ADMIN_PASS"], secret: ENV["GW_SUPER_ADMIN_2FA_SECRET"])
      click_link("User Details")
      fill_in "Username, email address or phone number", with: from_address
      click_button "Find user details"
      expect(page).to have_content("Nothing found")
    end
  end
  it "signs up successfully" do
    send_email(from_address: client_address, to_address: signup_address, body: "go")
    message = fetch_reply(from_address: notify_address, to_address: client_address)
    set_read_flag(message:)

    username, password = parse_message(message:)
    result = do_eapol_tests(ssid: "GovWifi",
                            username:,
                            password:,
                            radius_ips: ENV["RADIUS_IPS"].split(","),
                            secret: ENV["RADIUS_KEY"])
    expect(result).to all(be true)
  end
end