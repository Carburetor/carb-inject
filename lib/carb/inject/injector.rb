require "carb/inject/definition"

module Carb
  module Inject
    # Creates an injector with the specified container
    class Injector
      private

      attr_reader :container

      public

      def initialize(container)
        @container = container
      end

      def [](*dependencies, **aliased_dependencies)
        deps = merge_dependencies(dependencies, aliased_dependencies)
        Carb::Inject::Definition.new(container, deps)
      end

      private

      def merge_dependencies(dependencies, aliased_dependencies)
        deps = {}

        dependencies.each { |name| deps[name] = name }
        aliased_dependencies.each { |aliased, name| deps[aliased] = name }

        deps
      end
    end
  end
end
