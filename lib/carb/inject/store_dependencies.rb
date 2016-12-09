require "carb-core"
require "carb/inject/dependency_list_cache_name"

module Carb::Inject
  # Store dependencies on the specified object, setting instance variables
  #   having as name the key of the hash and as value the value of the hash
  # @api private
  class StoreDependencies
    def call(injectable, **dependencies)
      @injectable   = injectable
      @dependencies = dependencies

      inject_on(injectable.class)
    end

    private

    attr_reader :injectable
    attr_reader :dependencies

    def inject_on(klass)
      return unless dependency_list_present?(klass)

      parent_class = klass.superclass
      inject_on(klass.superclass) if dependency_list_present?(parent_class)

      list = dependency_list_for(klass)
      store_using_dependency_list(list)
    end

    def store_using_dependency_list(list)
      list.each do |name, dependency|
        # Ensure `nil` is an acceptable dependency
        dependency = dependencies[name] if dependencies.has_key?(name)
        injectable.instance_variable_set(:"@#{ name }", dependency)
      end
    end

    def dependency_list_present?(klass)
      klass.instance_variable_defined?(DependencyListCacheName)
    end

    def dependency_list_for(klass)
      klass.instance_variable_get(DependencyListCacheName)
    end
  end
end
