require "spec_helper"
require "carb-inject"
require "support/simple_container"

describe Carb::Inject::Injector, type: :feature do
  it "injects dependencies automatically" do
    container = Carb::SimpleContainer.new({
      :foo       => -> { 123 },
      "carb.bar" => -> { "test" }
    })
    injector = Carb::Inject::Injector.new(container)
    klass = Class.new do
      include injector[:foo, bar: "carb.bar"]

      def output
        "#{foo} #{bar}"
      end
    end

    instance = klass.new

    expect(instance.output).to eq "123 test"
  end

  it "overwrite dependencies with passed arguments" do
    container = Carb::SimpleContainer.new({
      :foo       => -> { 123 },
      "carb.bar" => -> { "test" }
    })
    injector = Carb::Inject::Injector.new(container)
    klass = Class.new do
      include injector[:foo, bar: "carb.bar"]

      def output
        "#{foo} #{bar}"
      end
    end

    instance = klass.new(foo: "blah")

    expect(instance.output).to eq "blah test"
  end
end
