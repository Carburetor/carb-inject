module Carb
  # Simple container for holding dependencies
  class SimpleContainer
    private

    attr_reader :dependencies

    public

    # @param dependencies [Hash{Object => Proc}] dependency name with proc
    #   as value, which will be `call`ed to extract the dependency object
    def initialize(dependencies)
      @dependencies = dependencies.dup
    end

    def register(name, dependency)
      unless dependency.respond_to?(:call)
        raise TypeError, "dependency must be a Proc"
      end
      if dependencies.has_key?(name)
        raise ArgumentError, "name already registered"
      end

      dependencies[name] = dependency
    end

    def [](name)
      dependencies[name].call
    end

    def has_key?(name)
      dependencies.has_key?(name)
    end
  end
end
