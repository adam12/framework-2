require "test_init"
require "framework/plugins/http_router/middleware_stack"

module Framework
  module Plugins
    module HttpRouter
      class TestMiddlewareStack < Framework::TestCase
        def setup
          super
          @stack = MiddlewareStack.new
        end

        def test_use
          middleware = Object.new
          @stack.use(middleware)
          assert_equal [[middleware, [], nil]], @stack.to_a
        end

        def test_use_with_args
          middleware = Object.new
          args = Object.new
          @stack.use(middleware, args)
          assert_equal [[middleware, [args], nil]], @stack.to_a
        end

        def test_default_stack
          stack = MiddlewareStack.default

          refute_empty stack.to_a
        end
      end
    end
  end
end
