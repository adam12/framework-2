require "test_init"
require "framework"
require "framework-web"
require "framework-render"

module Framework
  module Plugins
    class TestRender < Framework::TestCase
      def build_application
        Class.new(Framework::Application) do
          plugin Framework::Plugins::Http
          plugin Framework::Plugins::Render
        end
      end

      def test_render
        application = build_application

        action = Class.new(application::Action) do
          def call
            render(__dir__ + "/render_test.str")
          end
        end

        env = Rack::MockRequest.env_for("/")
        assert_equal "Render test string\n", action.new.call(env)
      end

      def test_render_with_layout
        application = build_application

        action = Class.new(application::Action) do
          def call
            render(__dir__ + "/render_test.str", layout: __dir__ + "/layout.str")
          end
        end

        env = Rack::MockRequest.env_for("/")
        assert_equal "Layout with Render test string\n\n", action.new.call(env)
      end

      def test_render_with_locals
        application = build_application

        action = Class.new(application::Action) do
          def call
            render(__dir__ + "/render_with_locals.str", locals: {foobar: "foobar"})
          end
        end

        env = Rack::MockRequest.env_for("/")
        assert_equal "Render with locals foobar\n", action.new.call(env)
      end

      def test_render_layout_with_string
        application = build_application

        action = Class.new(application::Action) do
          def call
            render(content: "This is the content", layout: __dir__ + "/layout.str")
          end
        end

        env = Rack::MockRequest.env_for("/")
        assert_equal "Layout with This is the content\n", action.new.call(env)
      end

      def test_render_inline_content_without_layout
        application = build_application

        action = Class.new(application::Action) do
          def call
            render(content: "This is the content")
          end
        end

        env = Rack::MockRequest.env_for("/")
        assert_equal "This is the content", action.new.call(env)
      end

      def test_render_ambiguous_args
        application = build_application

        action = Class.new(application::Action) do
          def call
            render("some-template-file", content: "This is the content")
          end
        end

        env = Rack::MockRequest.env_for("/")
        ex = assert_raises(ArgumentError) do
          action.new.call(env)
        end

        assert_equal "Passing template and :content is ambiguous", ex.message
      end
    end
  end
end
