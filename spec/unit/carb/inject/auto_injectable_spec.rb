require "spec_helper"
require "carb/inject/injectable"
require "carb/inject/auto_injectable"

describe Carb::Inject::AutoInjectable do
  it "raises if initialized and class is not injectable" do
    klass = Class.new { include Carb::Inject::AutoInjectable }

    expect{klass.new}.to raise_error TypeError
  end

  it "doesn't raise if initialized and class is injectable" do
    klass = Class.new do
      include Carb::Inject::Injectable
      include Carb::Inject::AutoInjectable
    end

    klass.new
  end

  it "calls #inject_dependencies! with passed arguments if is injectable" do
    klass = Class.new do
      include Carb::Inject::AutoInjectable

      attr_accessor :injected

      def inject_dependencies!(**dependencies)
        self.injected = dependencies
      end
    end

    instance = klass.new(foo: "bar")

    expect(instance.injected).to eq foo: "bar"
  end
end
