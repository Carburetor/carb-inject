require "carb"
require "carb/inject/dependency_missing_error"

module Carb::Inject
  # Container which requests dependency in sequence to a list of containers
  # otherwise and if none returns, it raises
  class DelegateContainer
    private

    attr_reader :containers

    public

    # @param containers [Array<#[], #has_key?>] Must have at least one
    #   container
    def initialize(*containers)
      @containers = containers

      if containers.size < 1
        raise ArgumentError, "At least one container is required"
      end
    end

    # @param name [Object] dependency name
    # @return [Object] dependency for given name if present in any container
    #   (only the first in sequence is returned), otherwise raises
    # @raise [DependencyMissingError]
    def [](name)
      containers.each do |container|
        return container[name] if container.has_key?(name)
      end

      error_class = ::Carb::Inject::DependencyMissingError
      raise error_class.new(name), format(error_class::MESSAGE, name.to_s)
    end

    # @param name [Object] dependency name
    # @return [Boolean] true if dependency is present in any container, false
    #   otherwise
    def has_key?(name)
      containers.any? { |container| container.has_key?(name) }
    end
  end
end
