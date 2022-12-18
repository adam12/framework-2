require "test_init"
require "framework/plugins/render"

module Framework
  module Plugins
    class TestRender < Minitest::Test
      def test_render
        application = Class.new(Framework::Application) do
          plugin Framework::Plugins::Render
        end

        action = Class.new(application::FrameworkAction) do
          def call
            render(__dir__ + "/render_test.str")
          end
        end

        assert_equal "Render test string\n", action.new.call
      end

      def test_render_with_layout
        application = Class.new(Framework::Application) do
          plugin Framework::Plugins::Render
        end

        action = Class.new(application::FrameworkAction) do
          def call
            render(__dir__ + "/render_test.str", layout: __dir__ + "/layout.str")
          end
        end

        assert_equal "Layout with Render test string\n\n", action.new.call
      end

      def test_render_with_locals
        application = Class.new(Framework::Application) do
          plugin Framework::Plugins::Render
        end

        action = Class.new(application::FrameworkAction) do
          def call
            render(__dir__ + "/render_with_locals.str", foobar: "foobar")
          end
        end

        assert_equal "Render with locals foobar\n", action.new.call
      end
    end
  end
end
