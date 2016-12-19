require "carb"

module Carb::Inject
  # Provides an initializer which sets instance variables with names of
  # dependencies and as value the dependency itself.
  # Requires {#inject_dependencies!} to be available
  module AutoInjectable
    # Initializes the object with passed dependencies
    # @param dependencies [Hash] map where key is the name of the dependency
    #   and value is the actual dependency being injected
    # @raise [TypeError] raises if doesn't respond to {#inject_dependencies!}
    def initialize(**dependencies)
      unless respond_to?(:inject_dependencies!, true)
        raise TypeError, "#{ self.class } must be injectable"
      end

      inject_dependencies!(**dependencies)
    end
  end
end
