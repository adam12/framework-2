module Framework
  module Filter
    module Attributes
      def initialize(attrs = {})
        @_attrs = attrs

        attrs.each do |key, value|
          setter = "#{key}="

          if respond_to?(setter)
            send(setter, value)
          end
        end
      end

      def attributes
        @_attrs.keys.each_with_object({}) do |key, obj|
          obj[key] = public_send(key)
        end
      end

      def slice(...)
        attributes.slice(...)
      end
    end

    def self.included(base)
      base.class_eval do
        include Attributes
      end
    end
  end
end
