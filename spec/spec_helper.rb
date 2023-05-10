require "capybara/rspec"
require "rotp"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Capybara::DSL
end

require "./lib/capybara_config.rb"
Dir["./spec/support/*"].each { |f| puts f; require f }
Dir["./spec/system/*/shared_context.rb"].sort.each { |f| require f }
