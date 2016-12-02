require "carb/inject/dependency_list_cache_name"

module Carb
  module MockDependencyList
    # Create a mock for {::Carb::Inject::DependencyList} that can be used to
    # improve test readability
    # @param klass [Class] the class which you want to mock the DependencyList for
    # @param dependencies [Hash] dependency name and value, will be yield
    #   using {::Carb::Inject::DependencyList#each} in the same order
    #   as in the {Hash}
    # @return [Double] the double object which is used for mocking the
    #   DependencyList
    def mock_dependency_list(klass, **dependencies)
      dependency_list = double("DependencyList", each: nil)

      stub_each(dependency_list, dependencies)

      klass.instance_variable_set(dependency_list_cache_name, dependency_list)
    end

    private

    def stub_each(mock, dependencies)
      receiver = receive(:each)
      dependencies.each do |name, instance|
        receiver = receiver.and_yield(name, instance)
      end
      allow(mock).to(receiver)
    end

    def dependency_list_cache_name
      ::Carb::Inject::DependencyListCacheName
    end
  end
end
