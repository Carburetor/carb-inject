require "carb"

module Carb::Inject
  # Simple container for holding dependency hashmap with Lambda callable values
  class CallableContainer
    private

    attr_reader :dependencies

    public

    # @param dependencies [Hash{Object => Proc}] dependency name with proc
    #   as value, which will be `call`ed to extract the dependency object
    def initialize(dependencies)
      @dependencies = dependencies.dup
    end

    # @param name [Object] dependency name
    # @return [Object] dependency value for given name, obtained by calling
    #   lambda
    def [](name)
      dependencies.fetch(name).call
    end
  end
end
