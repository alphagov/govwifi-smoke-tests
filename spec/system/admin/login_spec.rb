feature "Login" do
  include_context "admin"

  describe "Logging in" do
    it "logs in the user successfully" do
      login
      expect(page).to have_content "Overview"
    end
  end
end
