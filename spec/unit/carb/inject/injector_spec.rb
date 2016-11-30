require "spec_helper"
require "carb/inject/injector"
require "carb/inject/definition"

describe Carb::Inject::Injector do
  it "creates a new Definition with passed container" do
    injector = Carb::Inject::Injector.new({})

    expect(injector[]).to be_a Carb::Inject::Definition
  end

  it "creates a new Definition passing merged dependencies and aliases" do
    allow(Carb::Inject::Definition).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    definition = injector[:foo, bar: :baz]

    expect(definition).to be_a Carb::Inject::Definition
    expect(Carb::Inject::Definition).to have_received(:new)
      .with(container, { foo: :foo, bar: :baz })
  end

  it "merging gives priority to aliases over normal dependencies" do
    allow(Carb::Inject::Definition).to receive(:new).and_call_original
    container = {}
    injector  = Carb::Inject::Injector.new(container)

    definition = injector[:foo, bar: :baz, foo: :blah]

    expect(Carb::Inject::Definition).to have_received(:new)
      .with(container, { foo: :blah, bar: :baz })
  end
end
