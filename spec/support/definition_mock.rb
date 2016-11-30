module Carb
  module Test
    module Inject
      # Create a mock for {::Carb::Inject::Definition} that can be used to
      # improve test readability
      # @param klass [Class] the class which you want to mock the Definition for
      # @param dependencies [Hash] dependency name and value, will be yield
      #   using {::Carb::Inject::Definition#each_dependency} in the same order
      #   as in the {Hash}
      # @param expect_new [Boolean] if true, expects {#new} to receive as
      #   arguments the dependecies passed for mocking
      # @return [Double] the double object which is used for mocking the
      #   Definition
      def mock_definition(klass, dependencies, expect_new: true)
        definition = double("Definition", each_dependency: nil)

        stub_each_dependency(definition, dependencies)
        expect_new_to_receive_dependencies(klass, dependencies) if expect_new

        klass.instance_variable_set(:@__carb_inject_definition__, definition)
      end

      private

      def stub_each_dependency(mock, dependencies)
        receiver = receive(:each_dependency)
        dependencies.each do |name, instance|
          receiver = receiver.and_yield(name, instance)
        end
        allow(mock).to(receiver)
      end

      def expect_new_to_receive_dependencies(klass, dependencies)
        expect(klass).to receive(:new)
          .with(hash_including(dependencies))
          .and_call_original
      end
    end
  end
end
