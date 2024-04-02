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
    end

    # Set up decorator utility for provided value
    def self.[](value)
      case value
      when String
        StringDecorator.new(value)
      else
        value
      end
    end
  end
end
