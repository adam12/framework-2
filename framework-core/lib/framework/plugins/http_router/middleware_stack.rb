# frozen-string-literal: true

module Framework
  module Plugins
    module HttpRouter
      class MiddlewareStack
        def initialize
          @stack = []
        end

        def use(middleware, *args)
          @stack.push [middleware, args]
        end

        def last
          @stack.last
        end

        def each(&blk)
          @stack.each(&blk)
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
