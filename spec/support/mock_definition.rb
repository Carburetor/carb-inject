require "carb/inject/definition_cache_name"

module Carb
  module MockDefinition
    # Create a mock for {::Carb::Inject::Definition} that can be used to
    # improve test readability
    # @param klass [Class] the class which you want to mock the Definition for
    # @param dependencies [Hash] dependency name and value, will be yield
    #   using {::Carb::Inject::Definition#each_dependency} in the same order
    #   as in the {Hash}
    # @return [Double] the double object which is used for mocking the
    #   Definition
    def mock_definition(klass, **dependencies)
      definition = double("Definition", each_dependency: nil)

      stub_each_dependency(definition, dependencies)

      klass.instance_variable_set(definition_cache_name, definition)
    end

    private

    def stub_each_dependency(mock, dependencies)
      receiver = receive(:each_dependency)
      dependencies.each do |name, instance|
        receiver = receiver.and_yield(name, instance)
      end
      allow(mock).to(receiver)
    end

    def definition_cache_name
      ::Carb::Inject::DefinitionCacheName
    end
  end
end
