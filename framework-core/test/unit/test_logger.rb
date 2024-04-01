require "test_init"
require "framework"

class Framework::TestLogger < Framework::TestCase
  def test_log_info
    logger = Framework::Logger

    logger.info { "This is a test message" }
  end
end
