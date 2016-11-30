require "carb/inject/definition_cache_name"

module Carb
  module Inject
    # Store dependencies on the specified object, setting instance variables
    #   having as name the key of the hash and as value the value of the hash
    # @api private
    class DependencyStorer
      def call(injectable, **dependencies)
        @injectable   = injectable
        @dependencies = dependencies

        inject_on(injectable.class)
      end

      private

      attr_reader :injectable
      attr_reader :dependencies

      def inject_on(klass)
        return unless definition_present_for?(klass)

        inject_on(klass.superclass) if definition_present_for?(klass.superclass)

        definition = definition_for(klass)
        store_using_definition(definition)
      end

      def store_using_definition(definition)
        definition.each_dependency do |name, dependency|
          # Ensure `nil` is an acceptable dependency
          dependency = dependencies[name] if dependencies.has_key?(name)
          injectable.instance_variable_set(:"@#{ name }", dependency)
        end
      end

      def definition_present_for?(klass)
        klass.instance_variable_defined?(DefinitionCacheName)
      end

      def definition_for(klass)
        klass.instance_variable_get(DefinitionCacheName)
      end
    end
  end
end
