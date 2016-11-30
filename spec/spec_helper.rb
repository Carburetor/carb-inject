$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../", __FILE__)
require "pathname"
require "pry-byebug"

RSpec.configure do |config|
  config.mock_with :rspec do |mocks_config|
    mocks_config.verify_partial_doubles = true
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus unless ENV["COVERAGE"]
  config.filter_run_excluding broken: true

  config.expect_with :rspec do |expect_config|
    expect_config.syntax = :expect
  end
end
