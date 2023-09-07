require "test_init"
require "framework/variant"

class Framework::TestVariant < Framework::TestCase
  def test_force!
    original = Framework::Variant.default

    Framework::Variant.force!(:other)

    assert_equal :other, Framework::Variant.default
  ensure
    Framework::Variant.force!(original)
  end

  def test_default
    assert_equal :development, Framework::Variant.default
  end

  def test_predicate
    assert Framework::Variant.development?
  end
end
