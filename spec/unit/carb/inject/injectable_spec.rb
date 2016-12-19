require "spec_helper"
require "carb/inject/injectable"
require "carb/inject/store_dependencies"

describe Carb::Inject::Injectable do
  it "provides method to inject dependencies" do
    storer = instance_spy(Carb::Inject::StoreDependencies, call: nil)
    klass  = Class.new { include Carb::Inject::Injectable }

    expect(klass.protected_instance_methods).to include :inject_dependencies!
  end

  it "executes StoreDependencies#call when injecting dependencies" do
    storer = instance_spy(Carb::Inject::StoreDependencies, call: nil)
    klass  = Class.new do
      include Carb::Inject::Injectable

      def initialize(**dependencies)
        inject_dependencies!(**dependencies)
      end
    end
    allow(Carb::Inject::StoreDependencies).to receive(:new).and_return(storer)

    instance = klass.new(foo: 2)

    expect(storer).to have_received(:call).with(instance, foo: 2)
  end
end
