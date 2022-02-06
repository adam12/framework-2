require "minitest/autorun"
require "framework"

class Framework::TestRouter < Minitest::Test
  def test_build_routes_const_lookup_failure
    application = Struct.new(:namespace).new("Foobar")

    ex = assert_raises(Framework::Errors::Error) do
      Framework::Router.build(application)
    end

    assert_match "Unable to find routes in 'Foobar::Routes'", ex.message
  end
end
