require "carb/inject/definition_cache_name"

module Carb
  module Inject
    class Definition < Module
      private

      attr_reader :container
      attr_reader :dependencies

      public

      def initialize(container, **dependencies)
        @container    = container
        @dependencies = dependencies
      end

      def included(klass)
        memoize_definition(klass)
        include_injectable(klass)
        define_readers(klass)
      end

      def each_dependency
        dependencies.each do |key, value|
          yield(key, container[value])
        end
      end

      private

      def dependency_names
        dependencies.keys
      end

      def memoize_definition(klass)
        klass.instance_variable_set(DefinitionCacheName, self)
      end

      def include_injectable(klass)
        klass.include(::Carb::Inject::Injectable)
      end

      def define_readers(klass)
        dependencies.each do |name, _|
          define_reader(klass, name.to_s)
        end
      end

      def define_reader(klass, name)
        unless klass.respond_to?(name)
          klass.send(:attr_reader, name)
          klass.send(:protected, name)
        end
      end
    end
  end
end
