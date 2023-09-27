require_relative "../lib/services"
module NotifyEmail
  def parse_email_message(message:)
    data = message.payload.parts.first.body.data
    match = /Your username:[\n\r\s]*(?<username>[a-z]{6})[\n\r\s]*Your password:[\n\r\s]*(?<password>(?:[A-Z][a-z]+){3})/.match(data)
    [match[:username], match[:password]]
  end

  def send_email(to_address:, from_address:, subject: "", body: "")
    message = Google::Apis::GmailV1::Message.new
    message.raw = [
      "From: #{from_address}",
      "To: #{to_address}",
      "Subject: #{subject}",
      "",
      body,
    ].join("\n")
    Services.gmail.send_user_message("me", message)
  end

  def from_address
    Services.gmail.get_user_profile("me").email_address
  end

  def read_email(query: "")
    messages = Services.gmail.list_user_messages("me", q: query).messages
    return if messages.nil?

    Services.gmail.get_user_message("me", messages[0].id)
  end

  def fetch_reply(query:, timeout: 300)
    Timeout.timeout(timeout, nil, "Waited too long for signup email") do
      while (message = read_email(query:)).nil?
        print "."
        sleep 2
      end
      message
    end
  end

  def set_all_messages_to_read(query:)
    messages = Services.gmail.list_user_messages("me", q: query).messages || []

    messages.each do |message|
      Services.gmail.modify_message("me",
                                    message.id,
                                    Google::Apis::GmailV1::ModifyMessageRequest.new(remove_label_ids: %w[UNREAD]))
    end
  end
end
