require_relative "../../../lib/services"

feature "Eap-tls Journey" do
  it "can connect successfully" do
    eapol_test = GovwifiEapoltest.new(radius_ips: ENV["RADIUS_IPS"].split(","),
                                      secret: ENV["RADIUS_KEY"])

    cert_file = Tempfile.new
    cert_file.write ENV["EAP_TLS_CLIENT_CERT"]
    cert_file.close

    key_file = Tempfile.new
    key_file.write ENV["EAP_TLS_CLIENT_KEY"]
    key_file.close

    output = eapol_test.run_eap_tls(client_cert_path: cert_file.path,
                                    client_key_path: key_file.path)

    expect(output).to all(have_been_successful), output.join("\n")
  end
end
