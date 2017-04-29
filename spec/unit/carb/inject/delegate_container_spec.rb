require "spec_helper"
require "carb/inject/delegate_container"
require "carb/inject/dependency_missing_error"

describe Carb::Inject::DelegateContainer do
  describe "#[]" do
    it "is key from main_container when present" do
      main      = { foo: 1 }
      backup    = { bar: 2 }
      delegator = Carb::Inject::DelegateContainer.new(main, backup)

      expect(delegator[:foo]).to eq 1
    end

    it "is key from backup_container when present only in backup" do
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
end
