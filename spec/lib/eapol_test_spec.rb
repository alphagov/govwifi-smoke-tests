require "services"
require "securerandom"
require_relative "../../lib/eapol_test"

include EapolTest

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

describe EapolTest do
  describe "#do_eapol_test" do
    let(:fake_eapol_test) { FakeEapolTest.new }
    before :each do
      allow(Services).to receive(:eapol_test).and_return(fake_eapol_test)
    end
    it "passes a temporary config file with the correct parameters filled in" do
      do_eapol_tests(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1"], secret: "secret")
      expect(fake_eapol_test.config_file).to include("ssid=\"GovWifi\"")
      expect(fake_eapol_test.config_file).to include("identity=\"user\"")
      expect(fake_eapol_test.config_file).to include("password=\"pass\"")
    end
    it "runs eapol_test twice, with both radius ips" do
      do_eapol_tests(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1", "2.2.2.2"], secret: "secret")
      expect(fake_eapol_test.radius_ips).to eq(["1.1.1.1", "2.2.2.2"])
    end
    it "runs eapol_test with the correct secret" do
      do_eapol_tests(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1"], secret: "secret")
      expect(fake_eapol_test.secret).to eq("secret")
    end
    it "returns the status of each radius call" do
      allow(fake_eapol_test).to receive(:run).and_return("SOMETHING\nSUCCESS", "SOMETHING\nFAILURE")
      result = do_eapol_tests(ssid: "GovWifi", username: "user", password: "pass", radius_ips: ["1.1.1.1", "2.2.2.2"], secret: "secret")
      expect(result).to eq([true, false])
    end
  end
end
