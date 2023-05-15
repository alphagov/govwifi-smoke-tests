require "erb"

module EapolTest
  TEMPLATE_PATH = "#{File.dirname(__FILE__)}/peap-mschapv2.conf.erb".freeze

  def do_eapol_tests(ssid:, username:, password:, radius_ips:, secret:)
    eapol_test_template = ERB.new(File.read(TEMPLATE_PATH))
    eapol_test_file_contents = eapol_test_template.result_with_hash(
      ssid: ssid,
      identity: username,
      password: password,
      )
    eapol_test_file = Tempfile.new("govwifi-smoketest")
    begin
      eapol_test_file.write(eapol_test_file_contents)
      eapol_test_file.close
      radius_ips.map do |radius_ip|
        result = Services.eapol_test.run(config_file_path: eapol_test_file.path, radius_ip: radius_ip, secret: secret)
        result.split("\n").last == "SUCCESS"
      end
    ensure
      eapol_test_file.unlink
    end
  end
end
