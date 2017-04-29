require "carb"
require "carb/inject/dependency_missing_error"

module Carb::Inject
  # Container which requests dependency to a main container and if
  # not found, requests them to the backup container
  class DelegateContainer
    private

    attr_reader :main_container
    attr_reader :backup_container

    public

    # @param main_container [#[], #has_key?] Must be a container
    #   object which implements has_key? to check if it owns a
    #   given dependency
    # @param backup_container [#[], #has_key?] Container used in case
    #   {#has_key?} returns false for the main_container
    def initialize(main_container, backup_container)
      @main_container   = main_container
      @backup_container = backup_container
    end

    # @param name [Object] dependency name
    # @return [Object] dependency for given name if present in main_container,
    #   otherwise in backup_container, otherwise it raises
    # @raise [DependencyMissingError]
    def [](name)
      return main_container[name]   if main_container.has_key?(name)
      return backup_container[name] if backup_container.has_key?(name)

      error_class = ::Carb::Inject::DependencyMissingError
      raise error_class.new(name), format(error_class::MESSAGE, name.to_s)
    end

    # @param name [Object] dependency name
    # @return [Boolean] true if dependency is present in main_container or
    #   backup_container, false otherwise
    def has_key?(name)
      main_container.has_key?(name) || backup_container.has_key?(name)
    end
  end
end
