module Framework
  module Utils
    module String
      # Transform multiline heredoc into single line
      #
      # Remove any newlines and replace multiple spaces with a single space.
      def self.squeeze_heredoc(value)
        value.delete("\n").gsub(/\s+/, " ")
      end
    end
  end
end
