require "carb/inject/definition_cache_name"
require "carb/inject/dependency_storer"

module Carb
  module Inject
    # Provides an initializer which sets instance variables with names of
    # dependencies and as value the dependency itself
    module Injectable
      # Initializes the object with passed dependencies
      # @param dependencies [Hash] map where key is the name of the dependency
      #   and value is the actual dependency being injected
      def initialize(**dependencies)
        dependency_storer = DependencyStorer.new
        dependency_storer.(self, **dependencies)
      end
    end
  end
end
