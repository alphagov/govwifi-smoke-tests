RSpec.shared_context "signup", shared_context: :metadata do
  before(:all) do
    unless ENV["GOOGLE_API_CREDENTIALS"] && ENV["RADIUS_KEY"] && ENV["RADIUS_IPS"] && ENV["SUBDOMAIN"]
      abort "\e[31mMust define GOOGLE_API_CREDENTIALS, RADIUS_KEY, RADIUS_IPS and SUBDOMAIN\e[0m"
    end
  end
end
