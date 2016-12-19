require "carb"
require "carb/inject/injectable"

module Carb::Inject
  # Provides an initializer which sets instance variables with names of
  # dependencies and as value the dependency itself.
  # Requires {Injectable#inject_dependencies!} to be available
  module AutoInjectable
    # Initializes the object with passed dependencies
    # @param dependencies [Hash] map where key is the name of the dependency
    #   and value is the actual dependency being injected
    # @raise [TypeError] raises if class doesn't include
    #   {::Carb::Inject::Injectable}
    def initialize(**dependencies)
      unless self.is_a?(::Carb::Inject::Injectable)
        raise TypeError, "#{ self.class } must be Injectable"
      end

      inject_dependencies!(**dependencies)
    end
  end
end
