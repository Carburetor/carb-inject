require "carb"
require "carb/inject/dependency_list_cache_name"
require "carb/inject/store_dependencies"

module Carb::Inject
  # Provides a method which sets instance variables with names of
  # dependencies and as value the dependency itself
  module Injectable
    protected

    # Inject passed dependencies
    # @param dependencies [Hash] map where key is the name of the dependency
    #   and value is the actual dependency being injected
    def inject_dependencies!(**dependencies)
      store_dependencies = StoreDependencies.new
      store_dependencies.(self, **dependencies)
    end
  end
end
