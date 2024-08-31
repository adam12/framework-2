require "test_init"

class Framework::Plugins::Http::TestAction < Framework::TestCase
  def test_handle_error_custom
    application = Class.new(Framework::Application) do
      plugin Framework::Plugins::Http
    end

    action = Class.new(application::Action) do
      def call
        raise "Trigger handler"
      end

      def handle_error(ex)
        raise "Oh noes"
      end
    end

    env = Rack::MockRequest.env_for("/")
    ex = assert_raises(RuntimeError) do
      action.call(env)
    end

    assert_equal "Oh noes", ex.message
  end
end
