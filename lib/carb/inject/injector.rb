require "carb/inject/definition"

module Carb
  module Inject
    # Creates an injector with the specified container
    class Injector
      private

      attr_reader :container

      public

      # Initialize an injector that can be attached to a constant with the given
      # container
      # @param container [#[]] must return dependencies based on dependency name
      def initialize(container)
        @container = container
      end

      # @param dependencies [Array<#to_s>] Array of dependency names, which will
      #   be converted using {Object#to_s}, make sure the string version is a
      #   valid method name or it will raise, it will be used to create
      #   attr_readers on the object
      # @param aliased_dependencies [Hash{Symbol => Object}] alias => dependency
      #   name hash, the alias must be a valid method name or it will raise. The
      #   aliases will be used to create attr_readers which will return the
      #   dependency from the container
      # @return [Definition] module which can be included and will take care of
      #   automatically injecting not-supplied dependency
      # @raise [ArgumentError] if passed dependencies or aliased_dependencies
      #   contain objects not convertible to valid method names
      def [](*dependencies, **aliased_dependencies)
        deps = merge_dependencies(dependencies, aliased_dependencies)
        Carb::Inject::Definition.new(container, **deps)
      end

      private

      def merge_dependencies(dependencies, aliased_dependencies)
        deps = {}

        dependencies.each { |name| deps[name] = name }
        aliased_dependencies.each { |aliased, name| deps[aliased] = name }

        clean_names(deps)
      end

      def clean_names(dependencies)
        deps = {}

        dependencies.each do |aliased, name|
          deps[clean!(aliased.to_s)] = name
        end

        deps
      end

      def clean!(name)
        clean_name = name.gsub(".", "_").to_sym

        unless method_name?(clean_name)
          raise ArgumentError, "Invalid dependency name #{ name }"
        end

        clean_name
      end

      def method_name?(name)
        /[@$"]/ !~ name.inspect
      end
    end
  end
end
