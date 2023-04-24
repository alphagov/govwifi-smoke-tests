# frozen_string_literal: true

require "./lib/services"
module NotifySms
  TEMPLATE_PATH = File.dirname(__FILE__) + "/peap-mschapv2.conf.erb"

  def send_go_message(phone_number:, template_id:)
    Services.notify.send_sms(
      phone_number: phone_number,
      template_id: template_id,
    )
  end

  def read_reply_sms(phone_number: "", after_id: "", timeout: 50)
    Timeout.timeout(timeout, nil, "Waited too long for signup email") do
      while (result = get_first_sms(phone_number: phone_number)).id == after_id
        sleep 1
      end
      result.content
    end
  end

  def get_first_sms(phone_number:)
    Services.notify.get_received_texts.collection.find { |message| message.user_number == phone_number }
  end

  def parse_message(message)
    match = /(Username:\n(?<username>[a-z]{6}))\n(Password:\n(?<password>([A-Z][a-z]+){3}))/.match(message)
    [match[:username], match[:password]]
  end

  def do_eapol_test(ssid:, username:, password:, radius_ips:, secret:)
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
