require "test_init"
require "framework/plugins/http_router"

class Framework::Plugins::HttpRouter::TestMiddlewareStack < Framework::TestCase
  def test_use_middleware_pushes_to_bottom_of_stack
    stack.use :baz
    stack.use :foobar

    assert_equal [:foobar, []], stack.last
  end

  def test_iterate_through_stack
    stack.use :baz

    stack.each do |middleware, args|
      assert_equal :baz, middleware
      assert_equal [], args
    end
  end

  def test_default_stack_includes_body_parser
    stack = Framework::Plugins::HttpRouter::MiddlewareStack.default

    assert_includes stack.to_a, [Hanami::Middleware::BodyParser, [:json]]
  end

  def stack
    @stack ||= Framework::Plugins::HttpRouter::MiddlewareStack.new
  end
end

class Framework::Plugins::HttpRouter::TestBuilder < Minitest::Test
  def test_uses_middleware
    middleware = build_middleware
    middleware_stack.use middleware
    builder = Framework::Plugins::HttpRouter::Builder.new(middleware_stack, router)

    # First middleware in stack is used as outside application
    assert_kind_of middleware, builder.to_app
  end

  def middleware_stack
    @middleware_stack ||= Framework::Plugins::HttpRouter::MiddlewareStack.new
  end

  def router
    @router ||= [200, {}, ["OK"]]
  end

  # A class that matches the interface of Rack Middleware
  def build_middleware
    Class.new do
      def initialize(app)
        # No-op
      end
    end
  end
end
