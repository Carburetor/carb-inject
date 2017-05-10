require "spec_helper"
require "carb/inject/injector"
require "carb/inject/dependency_list"
require "carb/container/error_container"
require "carb/container/delegate_container"

describe Carb::Inject::Injector do
  ErrorContainer    = ::Carb::Container::ErrorContainer
  DelegateContainer = ::Carb::Container::DelegateContainer

  it "creates a new DependencyList with passed container" do
    injector = Carb::Inject::Injector.new({})

    expect(injector[]).to be_a Carb::Inject::DependencyList
  end

  it "creates a new DependencyList with passed auto_inject as true" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::Injector.new({}, true)

    dependency_list = injector[]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with({}, true, {})
  end

  it "creates a new DependencyList with default auto_inject as false" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::Injector.new({})

    dependency_list = injector[]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with({}, false, {})
  end

  it "creates a new DependencyList with default ErrorContainer" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::Injector.new

    dependency_list = injector[]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(kind_of(ErrorContainer), false, {})
  end

  it "creates a new DependencyList passing merged dependencies and aliases" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container, true)

    dependency_list = injector[:foo, bar: :baz]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(container, true, { foo: :foo, bar: :baz })
  end

  it "creates a new DependencyList passing lambdas" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::Injector.new

    dependency_list = injector[bar: -> { 123 }]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(kind_of(DelegateContainer), false, { bar: :bar })
  end

  it "merging gives priority to aliases over normal dependencies" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    dependency_list = injector[:foo, bar: :baz, foo: :blah]

    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(container, false, { foo: :blah, bar: :baz })
  end

  it "merging gives priority to lambdas over normal dependencies" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    dependency_list = injector[:foo, foo: -> { 123 }]

    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(kind_of(DelegateContainer), false, { foo: :foo })
  end

  it "clean names to work as valid method names" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container, true)

    dependency_list = injector["foo.bar", :"baz.lol" => "blah"]

    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(container, true, { foo_bar: "foo.bar", baz_lol: "blah" })
  end

  it "raises when can't convert dependency name to valid method name" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    expect{injector[{ "foo.bar" => "blah" }]}.to raise_error ArgumentError
  end

  it "raises when can't convert alias to valid method name" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    expect{injector[:"foo!?bar" => "blah"]}.to raise_error ArgumentError
  end
end
