$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pathname"
require "pry-byebug"

SPEC_SUPPORT_PATH = Pathname.new(File.expand_path("../support", __FILE__))
Dir[SPEC_SUPPORT_PATH.join("**/*.rb")].each { |f| require f }

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
