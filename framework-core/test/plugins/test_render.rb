require "test_init"
require "framework/plugins/render"

module Framework
  module Plugins
    class TestRender < Minitest::Test
      def test_render_method
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
    end
  end
end
