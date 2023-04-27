require_relative "../../../lib/google_mail"
require_relative "../../../lib/eapol_test"

feature "Signup" do
  include_context "signup"

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
          body = message.payload&.parts&.first&.body&.data
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

    time_now = Time.now
    radius_server_reboot_scheduled = time_now.between?(
      Time.new(time_now.year, time_now.month, time_now.day, 1, 0, 0),
      Time.new(time_now.year, time_now.month, time_now.day, 1, 15, 0),
    )

    unless radius_server_reboot_scheduled
      radius_ips = ENV["RADIUS_IPS"].split(",")

      radius_ips_successful = EapolTest.make_test(ssid: "GovWifi", identity:, password:) do |eapol_test|
        radius_ips.select do |radius_ip|
          eapol_test.execute(ENV["RADIUS_KEY"], radius_ip)
        end
      end

      expect(radius_ips_successful).to eq radius_ips
    end
  end
end
