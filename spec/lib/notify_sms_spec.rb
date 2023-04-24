require "notify_sms"
require "services"
require "securerandom"
include NotifySms

describe NotifySms do
  let(:phone_number) { "07700900000" }
  let(:notify_client) { instance_double(Notifications::Client) }

  before :each do
    allow(Services).to receive(:notify).and_return(notify_client)
  end

  describe "#send_go_message" do
    it "sends a go message to the phone number" do
      allow(notify_client).to receive(:send_sms)
      send_go_message(phone_number: phone_number, template_id: "notify_template_id")
      expect(notify_client).to have_received(:send_sms).with(phone_number: phone_number, template_id: "notify_template_id")
    end
  end

  describe "#send_go_message" do
    it "sends a go message to the phone number" do
      allow(notify_client).to receive(:send_sms)
      send_go_message(phone_number: phone_number, template_id: "notify_template_id")
      expect(notify_client).to have_received(:send_sms).with(phone_number: phone_number, template_id: "notify_template_id")
    end
  end

  describe "#read_reply_sms" do
    let(:new_message) { double(id: "new_id", user_number: phone_number, content: "new_body") }
    let(:old_message) { double(id: "old_id", user_number: phone_number, content: "old_body") }

    it "returns the first new message" do
      allow(notify_client).to receive(:get_received_texts).and_return(double(collection: [old_message]),
                                                                      double(collection: [new_message, old_message]))
      expect(read_reply_sms(phone_number: phone_number, after_id: "old_id", timeout: 2)).to eq "new_body"
    end

    it "times out" do
      allow(notify_client).to receive(:get_received_texts).and_return(double(collection: [old_message]))
      expect { read_reply_sms(phone_number: phone_number, after_id: "old_id", timeout: 2) }.to raise_error(Timeout::Error)
    end
  end

  describe "#get_first_sms" do
    let(:message1) { double(id: "id1", user_number: "07701111111", content: "body1") }
    let(:message2) { double(id: "id2", user_number: phone_number, content: "body2") }

    it "Ignores messages from other phone numbers" do
      allow(notify_client).to receive(:get_received_texts).and_return(double(collection: [message1, message2]))
      expect(get_first_sms(phone_number: phone_number).id).to eq("id2")
    end
  end

  describe "#parse_message" do
    it "parses the message" do
      message = <<~HTML
        Windows, Apple, and Chromebook users:
        Username:
        abcdef
        Password:
        DogCatFox
        Your password is case-sensitive with no spaces between words.

        Go to your wifi settings, select 'GovWifi' and enter your details.
      HTML
      expect(parse_message(message)).to eq %w[abcdef DogCatFox]
    end
  end

  class FakeEapolTest
    attr_reader :config_file, :radius_ips, :secret

    def initialize
      @radius_ips = []
    end

    def run(config_file_path:, radius_ip:, secret:)
      @config_file = File.read(config_file_path)
      @radius_ips << radius_ip
      @secret = secret
    end
  end

  describe "#do_eapol_test" do
    let(:fake_eapol_test) { FakeEapolTest.new }
    before :each do
      allow(Services).to receive(:eapol_test).and_return(fake_eapol_test)
    end
    it "passes a temporary config file with the correct parameters filled in" do
      do_eapol_test(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1"], secret: "secret")
      expect(fake_eapol_test.config_file).to include("ssid=\"GovWifi\"")
      expect(fake_eapol_test.config_file).to include("identity=\"user\"")
      expect(fake_eapol_test.config_file).to include("password=\"pass\"")
    end
    it "runs eapol_test twice, with both radius ips" do
      do_eapol_test(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1", "2.2.2.2"], secret: "secret")
      expect(fake_eapol_test.radius_ips).to eq(["1.1.1.1", "2.2.2.2"])
    end
    it "runs eapol_test with the correct secret" do
      do_eapol_test(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1"], secret: "secret")
      expect(fake_eapol_test.secret).to eq("secret")
    end
    it "returns the status of each radius call" do
      allow(fake_eapol_test).to receive(:run).and_return("SOMETHING\nSUCCESS", "SOMETHING\nFAILURE")
      result = do_eapol_test(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1", "2.2.2.2"], secret: "secret")
      expect(result).to eq([true, false])
    end
  end
end
