require "spec_helper"
require "carb/inject/dependency_list"
require "carb/inject/dependency_list_cache_name"
require "carb/inject/injectable"

describe Carb::Inject::DependencyList do
  it "raises if container can't be accessed using #[]" do
     expect{Carb::Inject::DependencyList.new(Object.new)}.to raise_error TypeError
  end

  it "raises if container is nil" do
     expect{Carb::Inject::DependencyList.new(nil)}.to raise_error TypeError
  end

  it "raises if included multiple times" do
    mod = Carb::Inject::DependencyList.new({})

    includer = -> do
      Class.new do
        include mod
        include mod
      end
    end

    expect{includer.call}.to raise_error TypeError
  end

  it "memoizes itself on including class" do
    mod = Carb::Inject::DependencyList.new({})

    klass      = Class.new { include mod }
    dependency_list = klass.instance_variable_get(Carb::Inject::DependencyListCacheName)

    expect(dependency_list).to eq mod
  end

  it "includes Injectable module on including class" do
    mod = Carb::Inject::DependencyList.new({})

    klass = Class.new { include mod }

    expect(klass < Carb::Inject::Injectable).to be true
  end

  it "defines protected attr_reader for each passed dependency" do
    mod   = Carb::Inject::DependencyList.new({ foo: 1 }, { foo: :foo })
    klass = Class.new { include mod }

    instance = klass.new

    expect(klass.protected_method_defined?(:foo)).to be true
    expect(instance.send(:foo)).to eq 1
  end

  it "defines attr_reader only if method doesn't exist already" do
    mod   = Carb::Inject::DependencyList.new({ foo: 1 }, { foo: :foo })
    klass = Class.new do
      include mod

      def foo
        123
      end
    end

    instance = klass.new

    expect(klass.protected_method_defined?(:foo)).to be false
    expect(klass.public_method_defined?(:foo)).to be true
    expect(instance.foo).to eq 123
  end

  it "defines attr_reader even if class method has same name" do
    mod   = Carb::Inject::DependencyList.new({ foo: 1 }, { foo: :foo })
    klass = Class.new do
      def self.foo
        456
      end

      include mod
    end

    instance = klass.new

    expect(klass.protected_method_defined?(:foo)).to be true
    expect(instance.send(:foo)).to eq 1
  end
end
