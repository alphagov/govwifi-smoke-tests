# frozen_string_literal: true

# EapolTest.create(ssid: "GovWifi", identity: "rmygfc", password: "RubyTapWave") { |t| t.execute("1DDA03BD0710FC6D6C25", "52.56.58.4") }

require "erb"

class EapolTest
  TEMPLATE_PATH = File.dirname(__FILE__) + "/peap-mschapv2.conf.erb"

  def self.create(*args)
    eapol_test = new(*args)
    result = yield eapol_test
    eapol_test.close
    result
  end

  def initialize(ssid:, identity:, password:)
    @file = Tempfile.new(EapolTest::TEMPLATE_PATH)
    generate(ssid, identity, password)
  end

  def execute(key, server)
    result = `eapol_test -r0 -t3 -c #{@file.path} -a #{server} -s #{key}`
    last_result = result.split("\n").last
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
                  ssid: ssid,
                  identity: identity,
                  password: password,
                ))
    @file.rewind
  end
end
