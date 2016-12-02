require "spec_helper"
require "carb/inject/injectable"
require "carb/inject/store_dependencies"

describe Carb::Inject::Injectable do
  it "executes StoreDependencies#call" do
    storer = instance_spy(Carb::Inject::StoreDependencies, call: nil)
    klass  = Class.new { include Carb::Inject::Injectable }
    allow(Carb::Inject::StoreDependencies).to receive(:new).and_return(storer)

    instance = klass.new(foo: 2)

    expect(storer).to have_received(:call).with(instance, foo: 2)
  end
end
