require 'capybara'
require 'capybara/dsl'

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium_headless
end
Capybara.app_host = "http://admin.#{ENV['SUBDOMAIN']}.service.gov.uk"
