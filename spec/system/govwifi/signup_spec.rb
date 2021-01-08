require "net/imap"
require "net/smtp"

feature "GovWifi" do
  include_context "govwifi"

  it "signs up successfully" do
    smtp = Net::SMTP.new("smtp.gmail.com", 25)
    smtp.enable_starttls_auto
    smtp.start

    smtp.authenticate(ENV["GMAIL_USER"], ENV["GMAIL_PASS"])

    smtp.send_message(
      "To: signup@staging.wifi.service.gov.uk\n" \
        "From: govwifi-tests@digital.cabinet-office.gov.uk\n" \
        "\n",
      ENV["GMAIL_USER"],
      "signup@staging.wifi.service.gov.uk",
    )

    body = nil

    Timeout.timeout(20, nil, "Waited too long for signup email") do
      imap = Net::IMAP.new("imap.googlemail.com", 993, true)
      imap.login(ENV["GMAIL_USER"], ENV["GMAIL_PASS"])

      loop do
        imap.select("Inbox")
        unread_ids = imap.uid_search("UNSEEN")
        unless unread_ids.empty?
          message = imap.uid_fetch(unread_ids, "ENVELOPE",)&.select { |m|
            /Welcome to (?:STAGING)? GovWifi/.match(m.attr["ENVELOPE"].subject)
          }&.first

          if message
            body = imap.uid_fetch(message.attr["UID"], "RFC822")[0].attr["RFC822"]
            imap.store(message.attr["UID"], "+FLAGS", [:Seen])

            puts
            break
          end
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
