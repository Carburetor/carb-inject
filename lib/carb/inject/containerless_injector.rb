require "carb"
require "carb/inject/dependency_list"
require "carb/inject/callable_container"

module Carb::Inject
  # Creates an injector without container
  class ContainerlessInjector
    private

    attr_reader :auto_inject
    attr_reader :callable_container

    public

    # Initialize an injector that can be attached to a constant
    # @param auto_inject [Boolean] if true, provides an initializer that auto
    #   injects dependencies by including {::Carb::Inject::AutoInjectable}
    # @param callable_container [Class] object used to resolve dependencies
    #   lambdas
    def initialize(auto_inject: false, callable_container: CallableContainer)
      @auto_inject        = auto_inject
      @callable_container = callable_container
    end

    # @param dependencies [Hash{Symbol => Proc}] dependency name => lambda
    #   returning the dependency
    # @return [DependencyList] module which can be included to ease-up
    #   dependency injection
    # @raise [ArgumentError] if passed dependencies contain invalid dependency
    #   names
    # @raise [TypeError] if dependency is not a lambda
    def [](**dependencies)
      deps      = build_dependencies(dependencies)
      container = callable_container.new(deps)
      aliases   = build_aliases(deps)

      Carb::Inject::DependencyList.new(container, auto_inject, **aliases)
    end

    private

    def build_dependencies(dependencies)
      clean_names(dependencies)
    end

    def build_aliases(dependencies)
      dependencies.each_with_object({}) do |(name, _), aliases|
        aliases[name] = name
      end
    end

    def clean_names(dependencies)
      deps = {}

      dependencies.each do |name, callable|
        callable!(name, callable)
        deps[clean!(name.to_s)] = callable
      end

      deps
    end

    def callable!(name, callable)
      unless callable.is_a?(::Proc)
        raise TypeError, "Dependency #{ name } is not a Lambda"
      end
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
