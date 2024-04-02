require "delegate"

module Framework
  module U
    class StringDecorator < DelegateClass(String)
      # Transform multiline heredoc into single line
      #
      # Remove any newlines and replace multiple spaces with a single space.
      def squeeze_heredoc
        delete("\n").gsub(/\s+/, " ")
      end

      def blank?
        strip.empty?
      end

      def present?
        !blank?
      end
    end

    class NilDecorator < DelegateClass(NilClass)
      def blank?
        true
      end

      def present?
        false
      end
    end

    class IntegerDecorator < DelegateClass(Integer)
      def blank?
        false
      end

      def present?
        true
      end
    end

    class HashDecorator < DelegateClass(Hash)
      ##
      # Deep symbolize all keys of the Hash.
      def deep_symbolize_keys
        each_with_object({}) { |(key, value), result|
          new_key =
            case key
            when ::String
              key.to_sym
            else
              key
            end

          new_value =
            case value
            when ::Hash then self.class.new(value).deep_symbolize_keys
            else value
            end

          result[new_key] = new_value
        }
      end
    end

    # Set up decorator utility for provided value
    def self.[](value)
      case value
      when nil
        NilDecorator.new(value)
      when ::String
        StringDecorator.new(value)
      when ::Integer
        IntegerDecorator.new(value)
      when ::Hash
        HashDecorator.new(value)
      else
        value
      end
    end
  end
end
