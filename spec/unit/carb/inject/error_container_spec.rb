require "spec_helper"
require "carb/inject/error_container"
require "carb/inject/dependency_missing_error"

describe Carb::Inject::ErrorContainer do
  describe "#[]" do
    it "raises every time a dependency is resolved" do
      container = Carb::Inject::ErrorContainer.new
      error     = Carb::Inject::DependencyMissingError

      expect { container[:foo] }.to raise_error error
    end
  end

  describe "#has_key?" do
    it "is always false" do
      container = Carb::Inject::ErrorContainer.new

      expect(container.has_key?(:foo)).to be false
    end
  end
end
