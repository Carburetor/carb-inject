module Carb
  module MockInjectable
    # Create a class with optional parent and an initializer which allows
    # dependency injection
    # @param parent [Class,nil]
    # @return [Class]
    def mock_injectable_class(parent = nil)
      if parent.nil?
        build_injectable_class
      else
        build_injectable_class_with_parent(parent)
      end
    end

    private

    def build_injectable_class_with_parent(parent)
      Class.new(parent) do
        def initialize(**dependencies)
        end
      end
    end

    def build_injectable_class
      Class.new do
        def initialize(**dependencies)
        end
      end
    end
  end
end
