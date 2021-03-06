# frozen-string-literal: true

module Framework
  module Utils
    ##
    # Convert string to Constant
    def constantize(value)
      Object.const_get(value)
    end
    module_function :constantize

    ##
    # Remove last constant from path
    #
    # deconstantize("Net::HTTP") # => "Net"
    # deconstantize("String") # => "String"
    def deconstantize(path)
      path = path.to_s
      if (pos = path.rindex("::"))
        path[0, pos]
      else
        path
      end
    end
    module_function :deconstantize

    ##
    # Remove module namespace from path, returning final constant
    #
    # demodulize("Net::HTTP") # => "HTTP"
    # demodulize("String") # => "String"
    def demodulize(path)
      path = path.to_s
      if (pos = path.rindex("::"))
        path[(pos + 2)..]
      else
        path
      end
    end
    module_function :demodulize
  end
end
