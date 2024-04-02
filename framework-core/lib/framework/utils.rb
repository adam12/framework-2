# frozen-string-literal: true

module Framework
  module Utils
    autoload :Blank, __dir__ + "/utils/blank"
    autoload :String, __dir__ + "/utils/string"
    autoload :Hash, __dir__ + "/utils/hash"

    # Warn functionality has been deprecated with original callsite location
    def deprecated(msg, uplevel: 1)
      warn msg, category: :deprecated, uplevel: uplevel
    end
    module_function :deprecated

    def self.blank?(value)
      Blank.blank?(value)
    end
  end
end
