require "spec_helper"
require "carb/inject/error_container"
require "carb/inject/dependency_missing_error"

describe Carb::Inject::ErrorContainer do
  it "raises every time a dependency is resolved" do
    container = Carb::Inject::ErrorContainer.new
    error     = Carb::Inject::DependencyMissingError

    expect { container[:foo] }.to raise_error error
  end
end
