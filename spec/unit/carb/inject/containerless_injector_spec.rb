require "spec_helper"
require "carb/inject/containerless_injector"
require "carb/inject/dependency_list"
require "carb/inject/callable_container"

describe Carb::Inject::ContainerlessInjector do
  it "creates a new DependencyList with passed container" do
    injector = Carb::Inject::ContainerlessInjector.new

    expect(injector[]).to be_a Carb::Inject::DependencyList
  end

  it "creates a new DependencyList with passed auto_inject as true" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::ContainerlessInjector.new(auto_inject: true)

    dependency_list = injector[]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(kind_of(Carb::Inject::CallableContainer), true, {})
  end

  it "creates a new DependencyList with default auto_inject as false" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::ContainerlessInjector.new

    dependency_list = injector[]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(kind_of(Carb::Inject::CallableContainer), false, {})
  end

  it "creates a new DependencyList passing dependencies with lambdas" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::ContainerlessInjector.new

    dependency_list = injector[foo: -> { 123 }]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(kind_of(Carb::Inject::CallableContainer), false, { foo: :foo })
  end

  it "clean names to work as valid method names" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::ContainerlessInjector.new

    dependency_list = injector[:"bz.fo" => -> { "blah" }]

    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(
        kind_of(Carb::Inject::CallableContainer),
        false,
        { bz_fo: :bz_fo }
      )
  end

  it "raises when can't convert dependency name to valid method name" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    injector = Carb::Inject::ContainerlessInjector.new

    expect{
      injector[{ :"foo!?bar" => -> { "blah" } }]
    }.to raise_error ArgumentError
  end
end
