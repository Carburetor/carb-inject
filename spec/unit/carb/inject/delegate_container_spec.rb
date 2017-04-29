require "spec_helper"
require "carb/inject/delegate_container"
require "carb/inject/dependency_missing_error"

describe Carb::Inject::DelegateContainer do
  it "raises when initialized without container" do
    delegator = -> { Carb::Inject::DelegateContainer.new() }

    expect { delegator.() }.to raise_error ArgumentError
  end

  describe "#[]" do
    it "is key from main_container when present" do
      main      = { foo: 1 }
      backup    = { bar: 2 }
      delegator = Carb::Inject::DelegateContainer.new(main, backup)

      expect(delegator[:foo]).to eq 1
    end

    it "is key from backup_container when not present in main" do
      main      = { foo: 1 }
      backup    = { bar: 2 }
      delegator = Carb::Inject::DelegateContainer.new(main, backup)

      expect(delegator[:bar]).to eq 2
    end

    it "raises when key missing in main and backup containers" do
      main      = { foo: 1 }
      backup    = { bar: 2 }
      delegator = Carb::Inject::DelegateContainer.new(main, backup)
      error     = Carb::Inject::DependencyMissingError

      expect { delegator[:baz] }.to raise_error error
    end
  end

  describe "#has_key?" do
    it "is true when key is present in main_container" do
      main      = { foo: 1 }
      backup    = { bar: 2 }
      delegator = Carb::Inject::DelegateContainer.new(main, backup)

      expect(delegator.has_key?(:foo)).to be true
    end

    it "is true when key is present only in backup_container" do
      main      = { foo: 1 }
      backup    = { bar: 2 }
      delegator = Carb::Inject::DelegateContainer.new(main, backup)

      expect(delegator.has_key?(:bar)).to be true
    end

    it "is false when key is missing from both containers" do
      main      = { foo: 1 }
      backup    = { bar: 2 }
      delegator = Carb::Inject::DelegateContainer.new(main, backup)

      expect(delegator.has_key?(:baz)).to be false
    end
  end
end
