require "test_init"

class Framework::Plugins::Http::TestResponse < Framework::TestCase
  def test_halt_with_no_arguments
    response = Framework::Plugins::Http::Response.new

    res = catch(:halt) do
      response.halt
    end

    assert_equal [200, {}, []], res
  end
end
