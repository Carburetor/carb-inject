require "spec_helper"
require "carb/inject/injector"
require "carb/inject/dependency_list"

describe Carb::Inject::Injector do
  it "creates a new DependencyList with passed container" do
    injector = Carb::Inject::Injector.new({})

    expect(injector[]).to be_a Carb::Inject::DependencyList
  end

  it "creates a new DependencyList passing merged dependencies and aliases" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    dependency_list = injector[:foo, bar: :baz]

    expect(dependency_list).to be_a Carb::Inject::DependencyList
    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(container, { foo: :foo, bar: :baz })
  end

  it "merging gives priority to aliases over normal dependencies" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    dependency_list = injector[:foo, bar: :baz, foo: :blah]

    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(container, { foo: :blah, bar: :baz })
  end

  it "clean names to work as valid method names" do
    allow(Carb::Inject::DependencyList).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    dependency_list = injector["foo.bar", :"baz.lol" => "blah"]

    expect(Carb::Inject::DependencyList).to have_received(:new)
      .with(container, { foo_bar: "foo.bar", baz_lol: "blah" })
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
