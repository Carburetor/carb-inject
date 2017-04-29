require "carb"

module Carb::Inject
  class DependencyMissingError < StandardError
    MESSAGE = "Dependency %s can't be fetched".freeze

    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end
