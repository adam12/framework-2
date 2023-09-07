require "test_init"
require "framework"

class Framework::TestApplication < Framework::TestCase
  def test_namespace_knows_its_ancestor_tree
    with_application do |app|
      assert_equal "ApplicationNamespace", app.namespace
    end
  end

  def test_plugins_cannot_be_loaded_twice
    loaded = 0

    p = Object.new
    p.define_singleton_method(:before_load) { |*| loaded += 1 }

    app = Class.new(Framework::Application)
    app.plugin(p)
    app.plugin(p)

    assert_equal 1, loaded
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
