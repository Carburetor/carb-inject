require "spec_helper"
require "support/mock_definition"
require "support/mock_injectable_class"
require "carb/inject/dependency_storer"


describe Carb::Inject::DependencyStorer do
  include ::Carb::MockDefinition
  include ::Carb::MockInjectable

  it "does nothing if class has no definition set" do
    storer   = Carb::Inject::DependencyStorer.new
    instance = Object.new

    storer.(instance, foo: 1, bar: 2)

    expect(instance.instance_variable_get(:@foo)).to be_nil
    expect(instance.instance_variable_get(:@bar)).to be_nil
  end

  it "doesn't set any instance variable if definition has none set" do
    storer   = Carb::Inject::DependencyStorer.new
    klass    = mock_injectable_class
    instance = klass.new(foo: 1, bar: 2)
    mock_definition(klass, {})

    storer.(instance)

    expect(instance.instance_variable_get(:@foo)).to be_nil
    expect(instance.instance_variable_get(:@bar)).to be_nil
  end

  it "sets instance variables based on definition" do
    storer   = Carb::Inject::DependencyStorer.new
    klass    = mock_injectable_class
    instance = klass.new
    mock_definition(klass, { foo: 1, bar: 2 })

    storer.(instance)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
  end

  it "overwrites instance variables from definition with those passed" do
    storer   = Carb::Inject::DependencyStorer.new
    klass    = mock_injectable_class
    instance = klass.new
    mock_definition(klass, { foo: 1, bar: 2 })

    storer.(instance, foo: 3)

    expect(instance.instance_variable_get(:@foo)).to eq 3
    expect(instance.instance_variable_get(:@bar)).to eq 2
  end

  it "sets instance variables for parent dependencies" do
    storer   = Carb::Inject::DependencyStorer.new
    parent   = mock_injectable_class
    klass    = mock_injectable_class(parent)
    instance = klass.new
    mock_definition(parent, { baz: 3 })
    mock_definition(klass, { foo: 1, bar: 2 })

    storer.(instance)

    expect(instance.instance_variable_get(:@foo)).to eq 1
    expect(instance.instance_variable_get(:@bar)).to eq 2
    expect(instance.instance_variable_get(:@baz)).to eq 3
  end
end
