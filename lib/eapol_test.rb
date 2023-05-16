# frozen_string_literal: true

require "erb"

class EapolTest
  TEMPLATE_PATH = "#{File.dirname(__FILE__)}/peap-mschapv2.conf.erb".freeze

  def self.make_test(ssid:, identity:, password:)
    eapol_test = new(ssid:, identity:, password:)
    result = yield eapol_test
    eapol_test.close
    result
  end

  def initialize(ssid:, identity:, password:)
    @file = Tempfile.new(EapolTest::TEMPLATE_PATH)
    generate(ssid, identity, password)
  end

  def execute(key, server)
    result = Services.eapol_test.run(config_file_path: @file.path, radius_ip: server, secret: key)
    last_result = result.split("\n").last

    unless last_result == "SUCCESS"
      warn result
    end

    last_result == "SUCCESS"
  end

  def close
    @file.close
    @file.unlink
  end

private

  def generate(ssid, identity, password)
    erb = ERB.new(File.read(EapolTest::TEMPLATE_PATH))

    @file.write(erb.result_with_hash(
                  ssid:,
                  identity:,
                  password:,
                ))
    @file.rewind
  end
end
