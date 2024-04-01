# frozen-string-literal: true

module Framework
  module Plugins
    module HttpRouter
      class MiddlewareStack
        def initialize
          @stack = []
        end

        def index(needle)
          return needle if needle.is_a?(Numeric)

          @stack.map { |el| el.first }.index(needle)
        end

        def use(middleware, *args, &block)
          @stack.push [middleware, args, block]
        end

        def before(neighbour, middleware, *args)
          idx = index(neighbour)
          @stack.insert idx, [middleware, args]
        end

        def after(neighbour, middleware, *args)
          idx = index(neighbour)
          @stack.insert idx + 1, [middleware, args]
        end

        def last
          @stack.last
        end

        def each(&)
          @stack.each(&)
        end

        def to_a
          @stack
        end

        def self.default
          new.tap do |stack|
            require "hanami/middleware/body_parser"
            stack.use Hanami::Middleware::BodyParser, :json
          end
        end
      end
    end
  end
end
