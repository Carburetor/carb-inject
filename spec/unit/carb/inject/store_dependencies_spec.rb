require "spec_helper"
require "support/mock_dependency_list"
require "support/mock_injectable_class"
require "carb/inject/store_dependencies"


describe Carb::Inject::StoreDependencies do
  include ::Carb::MockDependencyList
  include ::Carb::MockInjectable

  it "does nothing if class has no dependency_list set" do
    store    = Carb::Inject::StoreDependencies.new
    instance = Object.new

    store.(instance, foo: 1, bar: 2)

    expect(instance.instance_variable_get(:@foo)).to be_nil
    expect(instance.instance_variable_get(:@bar)).to be_nil
  end

  it "doesn't set any instance variable if dependency_list has none set" do
    store    = Carb::Inject::StoreDependencies.new
    klass    = mock_injectable_class
    instance = klass.new(foo: 1, bar: 2)
    mock_dependency_list(klass, {})

    store.(instance)

    expect(instance.instance_variable_get(:@foo)).to be_nil
    expect(instance.instance_variable_get(:@bar)).to be_nil
  end

  it "sets instance variables based on dependency_list" do
    store    = Carb::Inject::StoreDependencies.new
    klass    = mock_injectable_class
    instance = klass.new
    mock_dependency_list(klass, { foo: 1, bar: 2 })

    store.(instance)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
  end

  it "overwrites instance variables from dependency_list with those passed" do
    store    = Carb::Inject::StoreDependencies.new
    klass    = mock_injectable_class
    instance = klass.new
    mock_dependency_list(klass, { foo: 1, bar: 2 })

    store.(instance, foo: 3)

    expect(instance.instance_variable_get(:@foo)).to eq 3
    expect(instance.instance_variable_get(:@bar)).to eq 2
  end

  it "sets instance variables for parent dependencies" do
    store    = Carb::Inject::StoreDependencies.new
    parent   = mock_injectable_class
    klass    = mock_injectable_class(parent)
    instance = klass.new
    mock_dependency_list(parent, { baz: 3 })
    mock_dependency_list(klass, { foo: 1, bar: 2 })

    store.(instance)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
    expect(instance.instance_variable_get(:@baz)).to eq 3
  end
end
