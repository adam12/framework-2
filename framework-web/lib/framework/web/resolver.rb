# frozen-string-literal: true

module Framework
  class Resolver
    def initialize(application)
      @application = application
    end

    def call(_path, to)
      return to if to.is_a?(Proc)

      to
    end
  end
end
