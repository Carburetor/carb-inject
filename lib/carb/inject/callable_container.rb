require "carb"
require "carb/inject/dependency_missing_error"

module Carb::Inject
  # Simple container for holding dependency hashmap with Lambda callable values
  class CallableContainer
    private

    attr_reader :dependencies

    public

    # @param dependencies [Hash{Object => Proc}] dependency name with proc
    #   as value, which will be `call`ed to extract the dependency
    def initialize(dependencies)
      @dependencies = dependencies
    end

    # @param name [Object] dependency name
    # @return [Object] dependency for given name, obtained by calling lambda
    # @raise [DependencyMissingError]
    def [](name)
      return dependencies[name].call if has_key?(name)

      error_class = ::Carb::Inject::DependencyMissingError
      raise error_class.new(name), format(error_class::MESSAGE, name.to_s)
    end

    # @param name [Object] dependency name
    # @return [Boolean] true if dependency is present, false otherwise
    def has_key?(name)
      dependencies.has_key?(name)
    end
  end
end
