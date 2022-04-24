# frozen-string-literal: true

module Framework
  class Resolver
    def initialize(application)
      @application = application
    end

    def call(_path, to)
      return to unless to < Framework::Application::FrameworkAction

      # Provide application as first argument to call method
      to.method(:call).curry.call(@application)
    end
  end
end
