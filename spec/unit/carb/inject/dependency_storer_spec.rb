require "spec_helper"
require "support/mock_dependency_list"
require "support/mock_injectable_class"
require "carb/inject/dependency_storer"


describe Carb::Inject::DependencyStorer do
  include ::Carb::MockDependencyList
  include ::Carb::MockInjectable

  it "does nothing if class has no dependency_list set" do
    storer   = Carb::Inject::DependencyStorer.new
    instance = Object.new

    storer.call(instance, foo: 1, bar: 2)

    expect(instance.instance_variable_get(:@foo)).to be_nil
    expect(instance.instance_variable_get(:@bar)).to be_nil
  end

  it "doesn't set any instance variable if dependency_list has none set" do
    storer   = Carb::Inject::DependencyStorer.new
    klass    = mock_injectable_class
    instance = klass.new(foo: 1, bar: 2)
    mock_dependency_list(klass, {})

    storer.call(instance)

    expect(instance.instance_variable_get(:@foo)).to be_nil
    expect(instance.instance_variable_get(:@bar)).to be_nil
  end

  it "sets instance variables based on dependency_list" do
    storer   = Carb::Inject::DependencyStorer.new
    klass    = mock_injectable_class
    instance = klass.new
    mock_dependency_list(klass, { foo: 1, bar: 2 })

    storer.call(instance)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
  end

  it "overwrites instance variables from dependency_list with those passed" do
    storer   = Carb::Inject::DependencyStorer.new
    klass    = mock_injectable_class
    instance = klass.new
    mock_dependency_list(klass, { foo: 1, bar: 2 })

    storer.call(instance, foo: 3)

    expect(instance.instance_variable_get(:@foo)).to eq 3
    expect(instance.instance_variable_get(:@bar)).to eq 2
  end

  it "sets instance variables for parent dependencies" do
    storer   = Carb::Inject::DependencyStorer.new
    parent   = mock_injectable_class
    klass    = mock_injectable_class(parent)
    instance = klass.new
    mock_dependency_list(parent, { baz: 3 })
    mock_dependency_list(klass, { foo: 1, bar: 2 })

    storer.call(instance)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
    expect(instance.instance_variable_get(:@baz)).to eq 3
  end
end
