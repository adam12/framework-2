require "test_init"
require "framework"
require "framework-web"
require "framework-render"
require "framework/web/resolver"

module Framework
  module Plugins
    class TestRender < Minitest::Test
      def test_render
        application = Class.new(Framework::Application) do
          plugin Framework::Plugins::Http
          plugin Framework::Plugins::Render
        end

        action = Class.new(application::Action) do
          def call
            render(__dir__ + "/render_test.str")
          end
        end

        request_context = Framework::Resolver::RequestContext.build(
          env: Rack::MockRequest.env_for("/"),
          application: application.build
        )
        assert_equal "Render test string\n", action.new.call(request_context)
      end

      def test_render_with_layout
        application = Class.new(Framework::Application) do
          plugin Framework::Plugins::Http
          plugin Framework::Plugins::Render
        end

        action = Class.new(application::Action) do
          def call
            render(__dir__ + "/render_test.str", layout: __dir__ + "/layout.str")
          end
        end

        request_context = Framework::Resolver::RequestContext.build(
          env: Rack::MockRequest.env_for("/"),
          application: application.build
        )
        assert_equal "Layout with Render test string\n\n", action.new.call(request_context)
      end

      def test_render_with_locals
        application = Class.new(Framework::Application) do
          plugin Framework::Plugins::Http
          plugin Framework::Plugins::Render
        end

        action = Class.new(application::Action) do
          def call
            render(__dir__ + "/render_with_locals.str", foobar: "foobar")
          end
        end

        request_context = Framework::Resolver::RequestContext.build(
          env: Rack::MockRequest.env_for("/"),
          application: application.build
        )
        assert_equal "Render with locals foobar\n", action.new.call(request_context)
      end
    end
  end
end
