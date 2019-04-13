# frozen_string_literal: true

require "bundler/setup"
require "simplecov"
require "pry"
require "pry-byebug"
require "git/cop"

SimpleCov.start

Dir[Bundler.root.join("spec", "support", "shared_contexts", "**", "*.rb")].each do |file|
  require file
end

Dir[Bundler.root.join("spec", "support", "shared_examples", "**", "*.rb")].each do |file|
  require file
end

# Ensure CI environments are disabled for local testing purposes.
ENV["CIRCLECI"] = "false"
ENV["TRAVIS"] = "false"

RSpec.configure do |config|
  config.color = true
  config.order = "random"
  config.formatter = ENV["CI"] == "true" ? :progress : :documentation
  config.disable_monkey_patching!
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "./tmp/rspec-status.txt"
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
