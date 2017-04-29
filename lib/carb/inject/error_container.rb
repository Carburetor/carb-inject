require "carb"

module Carb::Inject
  # Container which holds no dependency and will raise every time
  # one is being fetched
  class ErrorContainer
    # Error raised when trying to fetch a dependency
    FetchError = Class.new(StandardError)

    # This method will always raise an error
    # @param name [Object] dependency name
    # @raise [::Carb::Inject::ErrorContainer::FetchError] raised
    #   whenever a dependency is being fetched from this container
    def [](name)
      raise FetchError, "Dependency #{name} can't be fetched " \
                        "from ErrorContainer"
    end
  end
end
