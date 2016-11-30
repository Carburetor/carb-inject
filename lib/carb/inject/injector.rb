module Carb
  module Inject
    # Takes care of setting instance variables with names of dependencies.
    # Initialize dependencies even for super classes
    module Injector
      # Initializes the object with passed dependencies
      # @param deps [Hash] a key value map where key is the name of the
      #   dependency and value is the actual dependency being injected
      def initialize(**deps)
        __carb_inject__(self.class, deps)
      end

      private

      def __carb_inject__(klass, deps)
        definition_name = :@__carb_inject_definition__

        return unless klass.instance_variable_defined?(definition_name)

        if klass.superclass.instance_variable_defined?(definition_name)
          __carb_inject__(klass.superclass, deps)
        end

        definition = klass.instance_variable_get(definition_name)
        definition.each_dependency do |name, dependency|
          # Ensure `nil` is an acceptable dependency
          dependency = deps[name] if deps.has_key?(name)
          instance_variable_set(:"@#{ name }", dependency)
        end
      end
    end
  end
end
