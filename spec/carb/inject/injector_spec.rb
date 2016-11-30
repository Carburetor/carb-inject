require "spec_helper"
require "carb/inject/injector"

describe Carb::Inject::Injector do
  include ::Carb::Test::Inject

  it "does nothing if class has no definition set" do
    klass = Class.new { include Carb::Inject::Injector }

    instance = klass.new(foo: 1, bar: 2)

    expect(instance.instance_variable_get(:@foo)).to be_nil
    expect(instance.instance_variable_get(:@bar)).to be_nil
  end

  it "sets instance variables for passed dependencies" do
    klass = Class.new { include Carb::Inject::Injector }
    mock_definition(klass, { foo: 1, bar: 2 })

    instance = klass.new(foo: 1, bar: 2)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
  end

  it "sets instance variables for parent dependencies" do
    parent = Class.new { include Carb::Inject::Injector }
    mock_definition(parent, { baz: 3 })
    klass  = Class.new(parent)
    mock_definition(klass, { foo: 1, bar: 2 })

    instance = klass.new(foo: 1, bar: 2, baz: 3)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
    expect(instance.instance_variable_get(:@baz)).to eq 3
  end
end
