# frozen_string_literal: true

require "notifications/client"
require "eapol_test"

module Services
  def self.notify
    @notify ||= Notifications::Client.new(ENV["NOTIFY_SMOKETEST_API_KEY"])
  end

  def self.eapol_test
    EapolTest
  end
end
