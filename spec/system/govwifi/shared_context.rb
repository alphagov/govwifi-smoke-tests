RSpec.shared_context "govwifi", shared_context: :metadata do
  before(:all) do
    unless ENV["GOOGLE_API_CREDENTIALS"]
      abort "\e[31mMust define GOOGLE_API_CREDENTIALS\e[0m"
    end
  end
end
