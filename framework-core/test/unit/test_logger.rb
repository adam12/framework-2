require "test_init"
require "framework"

class Framework::TestLogger < Minitest::Test
  def test_log_info
    logger = Framework::Logger

    logger.info { "This is a test message" }
  end
end
