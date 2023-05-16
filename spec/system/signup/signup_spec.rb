require_relative "../../../lib/google_mail"
require_relative "../../../lib/eapol_test"

feature "Signup" do
  include_context "signup"
  include EapolTest

  it "signs up successfully" do
    gmail = GoogleMail.new

    test_email = gmail.account_email.gsub(/@/, "+#{Time.now.to_i}@")

    emailaddress = "signup@#{ENV['SUBDOMAIN']}.service.gov.uk"

    gmail.send_email(
      emailaddress,
      test_email,
      "",
      "",
    )

    body = nil

    from_field = ENV["SUBDOMAIN"] == "wifi" ? "govwifi" : "govwifistaging"
    Timeout.timeout(50, nil, "Waited too long for signup email") do
      loop do
        if (message = gmail.read("from:#{from_field}@notifications.service.gov.uk is:unread to:#{test_email}"))
          body = message&.payload&.parts&.first&.body&.data
          break
        end

        print "."
        sleep 2
      end
    end

    identity = body.scan(/Your username:\r\n([a-z]{6})/)&.first&.first
    password = body.scan(/Your password:\r\n((?:[A-Z][a-z]+){3})/)&.first&.first

    expect(identity).to be
    expect(password).to be

    result = do_eapol_tests(ssid: "GovWifi",
                            username: identity,
                            password:,
                            radius_ips: ENV["RADIUS_IPS"].split(","),
                            secret: ENV["RADIUS_KEY"])
    expect(result).to all(be true)
  end
end
