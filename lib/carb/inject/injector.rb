require "carb"
require "carb/inject/dependency_list"
require "carb/inject/error_container"

module Carb::Inject
  # Creates an injector with the specified container
  class Injector
    private

    attr_reader :container
    attr_reader :auto_inject

    public

    # Initialize an injector that can be attached to a constant with the given
    # container
    # @param container [#[], #has_key?] must return dependencies based on
    #   dependency name
    # @param auto_inject [Boolean] if true, provides an initializer that auto
    #   injects dependencies by including {::Carb::Inject::AutoInjectable},
    #   false by default
    def initialize(container = ErrorContainer.new, auto_inject: false)
      @container   = container
      @auto_inject = auto_inject
    end

    # @param dependencies [Array<#to_s>] Array of dependency names, which will
    #   be converted using {Object#to_s}, make sure the string version is a
    #   valid method name or it will raise, it will be used to create
    #   attr_readers on the object
    # @param aliased_dependencies [Hash{Symbol => Object, Proc}] if value is
    #   an {Object}, alias => dependency name hash, the alias must be a valid
    #   method name or it will raise. The aliases will be used to create
    #   attr_readers which will return the dependency from the container.
    #   If value is {Proc}, an attr_reader with the key as bane is created and
    #   value the output of invoking the {Proc}
    # @return [DependencyList] module which can be included and will take care
    #   of automatically injecting not-supplied dependency
    # @raise [ArgumentError] if passed dependencies or aliased_dependencies
    #   contain objects not convertible to valid method names
    def [](*dependencies, **aliased_dependencies)
      deps = merge_dependencies(dependencies, aliased_dependencies)
      Carb::Inject::DependencyList.new(container, auto_inject, **deps)
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
