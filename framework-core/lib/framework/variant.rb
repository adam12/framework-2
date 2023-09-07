# frozen-string-literal: true

require "variant"

module Framework
  ##
  # Variants represent the different types of environments the application
  # might be running in, with common ones such as development, testing, and
  # production.
  #
  module Variant
    class << self
      ##
      # Force the variant to be the provided value for the duration of the
      # application's runtime.
      #
      #   Framework::Variant.force!(:testing) # => true
      def force!(value)
        ::Variant.force!(value)
      end

      ##
      # Retrieve the default variant.
      #
      # This value may be affected by use of the variant:* bake commands or via
      # the `VARIANT` environment variable, or via the `force!` method above.
      #
      #   Framework::Variant.default # => :development
      def default
        ::Variant.default
      end

      def for(*arguments)
        ::Variant.for(*arguments)
      end

      ##
      # Check if default variant matches predicate method.
      #
      #   Framework::Variant.development? # => true
      #   Framework::Variant.testing? # => false
      def method_missing(name, *args, &blk)
        super unless name.end_with?("?")

        default.to_s == name.to_s.delete_suffix("?")
      end

      def respond_to_missing?(name, include_private = false)
        name.end_with?("?") || super
      end
    end
  end
end
