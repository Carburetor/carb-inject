require "carb"

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
    def [](name)
      dependencies.fetch(name).call
    end

    # @param name [Object] dependency name
    # @return [Boolean] true if dependency is present, false otherwise
    def has_key?(name)
      dependencies.has_key?(name)
    end
  end
end
