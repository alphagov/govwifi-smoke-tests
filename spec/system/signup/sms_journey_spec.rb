require_relative "../../../lib/notify_sms"
require "notifications/client"
include NotifySms

feature "SMS Journey" do
  it "signs up using an SMS journey" do
    id = get_first_sms(phone_number: ENV["GOVWIFI_PHONE_NUMBER"]).id
    send_go_message(phone_number: ENV["GOVWIFI_PHONE_NUMBER"], template_id: ENV["NOTIFY_GO_TEMPLATE_ID"])
    message = read_reply_sms(phone_number: ENV["GOVWIFI_PHONE_NUMBER"], after_id: id)
    username, password = parse_message message
    result = do_eapol_test(ssid: "GovWifi",
                           username: username,
                           password: password,
                           radius_ips: ENV["RADIUS_IPS"].split(","),
                           secret: ENV["RADIUS_KEY"])
    expect(result).to all(be true)
  end
end
