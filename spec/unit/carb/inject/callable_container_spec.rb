require "spec_helper"
require "carb/inject/callable_container"
require "carb/inject/dependency_missing_error"

describe Carb::Inject::CallableContainer do
  describe "#[]" do
    it "resolves dependency running `call` on it" do
      container = Carb::Inject::CallableContainer.new({ foo: -> { 123 } })

      expect(container[:foo]).to eq 123
    end

    it "raises if key is missing" do
      container = Carb::Inject::CallableContainer.new({ foo: -> { 123 } })
      error     = Carb::Inject::DependencyMissingError

      expect { container[:bar] }.to raise_error error
    end
  end

  describe "#has_key?" do
    it "is true if key is present" do
      container = Carb::Inject::CallableContainer.new({ foo: -> { 123 } })

      expect(container.has_key?(:foo)).to be true
    end

    it "is false if key is missing" do
      container = Carb::Inject::CallableContainer.new({ foo: -> { 123 } })

      expect(container.has_key?(:bar)).to be false
    end
  end
end
