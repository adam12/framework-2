module Framework
  module Action
  end

  class Application
    def self.start
      ->(env) { [200, {}, ["OK"]] }
    end
  end

  class Routes
    def self.define
    end
  end
end
