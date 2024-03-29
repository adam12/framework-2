require "test_init"
require "framework/utils"

class Framework::TestUtils < Framework::TestCase
  def test_demodulize
    assert_equal "Inflections", Framework::Utils.demodulize("Framework::Inflections")
    assert_equal "", Framework::Utils.demodulize("")
  end

  def test_constantize
    assert_equal String, Framework::Utils.constantize("String")
    assert_equal Framework::Application, Framework::Utils.constantize("Framework::Application")
  end

  def test_deconstantize
    assert_equal "Net", Framework::Utils.deconstantize("Net::HTTP")
    assert_equal "String", Framework::Utils.deconstantize("String")
    assert_equal "", Framework::Utils.deconstantize("")
  end
end
