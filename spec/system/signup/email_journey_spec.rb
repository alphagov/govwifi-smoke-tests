require_relative "../../../lib/notify_email"
require_relative "../../../lib/eapol_test"
require_relative "../../../lib/services"

feature "Email Journey" do
  include NotifyEmail
  include EapolTest

  before :each do
    remove_user(user: from_address)
  end
  it "signs up successfully" do
    to_address = "signup@#{ENV['SUBDOMAIN']}.service.gov.uk"
    send_email(from_address:, to_address:, body: "go")

    notify_field = ENV["SUBDOMAIN"] == "wifi" ? "govwifi" : "govwifistaging"
    message = fetch_reply(from_address: "#{notify_field}@notifications.service.gov.uk", to_address: from_address)
    set_read_flag(message:)

    username, password = parse_message(message:)
    result = do_eapol_tests(ssid: "GovWifi",
                           username: username,
                           password: password,
                           radius_ips: ENV["RADIUS_IPS"].split(","),
                           secret: ENV["RADIUS_KEY"])
    expect(result).to all(be true)
  end
end
