require "spec_helper"
require "carb/inject/error_container"

describe Carb::Inject::ErrorContainer do
  it "raises every time a dependency is resolved" do
    container   = Carb::Inject::ErrorContainer.new
    fetch_error = Carb::Inject::ErrorContainer::FetchError

    expect { container[:foo] }.to raise_error fetch_error
  end
end
