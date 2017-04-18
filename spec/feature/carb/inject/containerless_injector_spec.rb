require "spec_helper"
require "carb-inject"

describe Carb::Inject::ContainerlessInjector, type: :feature do
  it "injects dependencies from lambdas" do
    injector = Carb::Inject::ContainerlessInjector.new
    klass = Class.new do
      include injector[bar: -> { 123 }]

      def initialize(**deps)
        inject_dependencies!(deps)
      end

      def output
        "hey #{bar}"
      end
    end

    instance = klass.new

    expect(instance.output).to eq "hey 123"
  end

  it "overwrite dependencies with passed arguments" do
    injector = Carb::Inject::ContainerlessInjector.new
    klass = Class.new do
      include injector[bar: -> { 123 }]

      def initialize(**deps)
        inject_dependencies!(deps)
      end

      def output
        "hey #{bar}"
      end
    end

    instance = klass.new(bar: "blah")

    expect(instance.output).to eq "hey blah"
  end
end
