require_relative "../../../lib/google_mail"

feature "GovWifi" do
  include_context "govwifi"

  it "signs up successfully" do
    gmail = GoogleMail.new

    test_email = gmail.account_email.gsub(/@/, "+#{Time.now.to_i}@")

    gmail.send(
      "signup@staging.wifi.service.gov.uk",
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

    username = body.scan(/Your username: ([a-z]+)/)&.first&.first
    password = body.scan(/Your password: ([a-zA-Z]+)/)&.first&.first

    expect(username).to be
    expect(password).to be
  end
end
