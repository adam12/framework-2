require "test_init"
require "framework/utils"

class Framework::TestUtils < Framework::TestCase
  def test_demodulize
    assert_equal "Inflections", Framework::Utils::String.demodulize("Framework::Inflections")
    assert_equal "", Framework::Utils::String.demodulize("")
  end

  def test_constantize
    assert_equal String, Framework::Utils::String.constantize("String")
    assert_equal Framework::Application, Framework::Utils::String.constantize("Framework::Application")
  end

  def test_deconstantize
    assert_equal "Net", Framework::Utils::String.deconstantize("Net::HTTP")
    assert_equal "String", Framework::Utils::String.deconstantize("String")
    assert_equal "", Framework::Utils::String.deconstantize("")
  end

  def test_deprecated
    assert_output(nil, /This is a test deprecation message/) do
      Framework::Utils.deprecated("This is a test deprecation message")
    end
  end
end
