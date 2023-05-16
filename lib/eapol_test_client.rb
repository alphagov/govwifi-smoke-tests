# frozen_string_literal: true

class EapolTestClient
  def self.run(config_file_path: nil, radius_ip: nil, secret: nil)
    `eapol_test -r2 -t9 -c #{config_file_path} -a #{radius_ip} -s #{secret}`
  end
end
