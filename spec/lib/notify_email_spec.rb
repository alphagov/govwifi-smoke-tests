require "notify_email"
require "services"
include NotifyEmail

describe NotifyEmail do
  describe "#parse_message" do
    it "parses the message" do
      raw = File.read(File.expand_path(File.join(File.dirname(__FILE__), "test_email.json")))
      message = Google::Apis::GmailV1::Message.from_json(raw)
      expect(parse_message(message:)).to eq %w[abcdef FoxCatBear]
    end
  end
end
