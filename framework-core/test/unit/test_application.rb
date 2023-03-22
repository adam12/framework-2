require "test_init"
require "framework"

class Framework::TestApplication < Minitest::Test
  def test_namespace_knows_its_ancestor_tree
    with_application do |app|
      assert_equal "ApplicationNamespace", app.namespace
    end
  end

  module ::ApplicationNamespace; end

  # Configure application class and yield created object
  # Cleanup once block returns.
  def with_application
    ApplicationNamespace.const_set(:App, Class.new(Framework::Application))

    yield ApplicationNamespace::App
  ensure
    ApplicationNamespace.send :remove_const, :App
  end
end
