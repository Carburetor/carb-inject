require "carb"
require "carb/inject/injectable"
require "carb/inject/auto_injectable"
require "carb/inject/dependency_list_cache_name"

module Carb::Inject
  # Provides the list of dependencies required by the object to be initialized
  class DependencyList < Module
    private

    attr_reader :container
    attr_reader :auto_inject
    attr_reader :dependencies

    public

    # Uses the passed container to resolve listed dependencies
    # @param container [#[]] resolve dependencies by using the value of
    #   `dependencies` hash passed to this initializer
    # @param auto_inject [Boolean] if true, includes
    #   {::Carb::Inject::AutoInjectable} which provides an initializer that
    #   inject dependencies automatically
    # @param dependencies [Hash{Symbol => Object}] a hash representing
    #   required dependencies for the object. The key represent the alias used
    #   to access the real dependency name, which is the value of the hash.
    #   If you want to access the dependency using its real name, just set the
    #   alias to the real name. Example: `{ alias: :real_name }`
    def initialize(container, auto_inject = true, **dependencies)
      ensure_correct_types!(container, dependencies)

      @container    = container
      @auto_inject  = auto_inject
      @dependencies = dependencies
    end

    def included(klass)
      memoize_dependency_list(klass)
      include_injectable(klass)
      define_readers(klass)
    end

    # Loops over each available dependency and yields it using its alias and
    # the dependency itself
    # @yieldparam name [Object] alias of the dependency for this dependency_list
    # @yieldparam dependency [Object] the dependency object for this container
    def each
      dependencies.each do |key, value|
        yield(key, container[value])
      end
    end

    private

    def dependency_names
      dependencies.keys
    end

    def memoize_dependency_list(klass)
      if klass.instance_variable_defined?(DependencyListCacheName)
        raise TypeError, "class already injecting"
      end

      klass.instance_variable_set(DependencyListCacheName, self)
    end

    def include_injectable(klass)
      klass.include(::Carb::Inject::Injectable)
      klass.include(::Carb::Inject::AutoInjectable) if auto_inject
    end

    def define_readers(klass)
      dependencies.each do |name, _|
        define_reader(klass, name.to_s)
      end
    end

    def define_reader(klass, name)
      unless klass.method_defined?(name)
        klass.send(:attr_reader, name)
        klass.send(:protected, name)
      end
    end

    def ensure_correct_types!(container, dependencies)
      raise TypeError, "container can't be nil" if container.nil?
      unless container.respond_to?(:[])
        raise TypeError, "container doesn't respond to #[]"
      end

      raise TypeError, "dependencies can't be nil" if dependencies.nil?
      unless dependencies.respond_to?(:[])
        raise TypeError, "dependencies doesn't respond to #[]"
      end
    end
  end
end
