module Framework
  module Utils
    module String
      # Transform multiline heredoc into single line
      #
      # Remove any newlines and replace multiple spaces with a single space.
      def self.squeeze_heredoc(value)
        value.delete("\n").gsub(/\s+/, " ")
      end

      # Convert string to Constant
      def self.constantize(value)
        Object.const_get(value)
      end

      # Remove last constant from path
      #
      # deconstantize("Net::HTTP") # => "Net"
      # deconstantize("String") # => "String"
      def self.deconstantize(path)
        if (pos = path.rindex("::"))
          path[0, pos]
        else
          path
        end
      end

      # Remove module namespace from path, returning final constant
      #
      # demodulize("Net::HTTP") # => "HTTP"
      # demodulize("String") # => "String"
      def self.demodulize(path)
        if (pos = path.rindex("::"))
          path[(pos + 2)..]
        else
          path
        end
      end
    end
  end
end
