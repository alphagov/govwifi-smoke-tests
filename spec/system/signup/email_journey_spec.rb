require_relative "../../../lib/notify_email"
require_relative "../../../lib/eapol_test"
require_relative "../../../lib/services"

feature "Email Journey" do
  include NotifyEmail
  include EapolTest

  let(:signup_address) { "signup@#{ENV['SUBDOMAIN']}.service.gov.uk" }
  let(:notify_address) do
    notify_field = "govwifidevelopment" #ENV["SUBDOMAIN"] == "wifi" ? "govwifi" : "govwifistaging"
    "#{notify_field}@notifications.service.gov.uk"
  end

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
    query = "from:#{notify_address} subject:Welcome is:unread to:#{from_address}"

    set_all_messages_to_read(query:)
    send_email(from_address:, to_address: signup_address, body: "go")
    message = fetch_reply(query:)

    username, password = parse_email_message(message:)
    expect(username).to_not be_nil
    expect(password).to_not be_nil

    radius_outcomes = do_eapol_tests(ssid: "GovWifi",
                                     username:,
                                     password:,
                                     radius_ips: ENV["RADIUS_IPS"].split(","),
                                     secret: ENV["RADIUS_KEY"])
    expect(radius_outcomes).to all(be true), "EAPOL tests failed for #{username}, #{password}"
  end
end
