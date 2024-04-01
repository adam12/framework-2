require "test_init"
require "framework"
require "framework-web"
require "framework-render"

module Framework
  module Plugins
    class TestRender < Framework::TestCase
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

        env = Rack::MockRequest.env_for("/")
        assert_equal "Render test string\n", action.new.call(env)
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

        env = Rack::MockRequest.env_for("/")
        assert_equal "Layout with Render test string\n\n", action.new.call(env)
      end

      def test_render_with_locals
        application = Class.new(Framework::Application) do
          plugin Framework::Plugins::Http
          plugin Framework::Plugins::Render
        end

        action = Class.new(application::Action) do
          def call
            render(__dir__ + "/render_with_locals.str", locals: {foobar: "foobar"})
          end
        end

        env = Rack::MockRequest.env_for("/")
        assert_equal "Render with locals foobar\n", action.new.call(env)
      end
    end
  end
end
