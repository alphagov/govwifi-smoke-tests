require_relative "../../../lib/google_mail"
require_relative "../../../lib/eapol_test"

feature "GovWifi" do
  include_context "govwifi"

  it "signs up successfully" do
    gmail = GoogleMail.new

    test_email = gmail.account_email.gsub(/@/, "+#{Time.now.to_i}@")

    gmail.send(
      "signup@wifi.service.gov.uk",
      test_email,
      "",
      "",
    )

    body = nil

    Timeout.timeout(20, nil, "Waited too long for signup email") do
      loop do
        if message = gmail.read("is:unread to:#{test_email}")
          body = message&.payload&.parts&.first&.body&.data
          break
        end

        print "."
        sleep 1
      end
    end

    identity = body.scan(/Your username: ([a-z]+)/)&.first&.first
    password = body.scan(/Your password: ([a-zA-Z]+)/)&.first&.first

    expect(identity).to be
    expect(password).to be

    radius_ips = ENV["RADIUS_IPS"].split(",")

    radius_ips_successful = EapolTest.create(ssid: "GovWifi", identity: identity, password: password) do |eapol_test|
      radius_ips.select do |radius_ip|
        eapol_test.execute(ENV["RADIUS_KEY"], radius_ip)
      end
    end

    expect(radius_ips_successful).to eq radius_ips
  end
end
