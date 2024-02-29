# frozen-string-literal: true

module Framework
  class Resolver
    def initialize(application)
      @application = application
    end

    def call(_path, to)
      to
    end
  end
end
