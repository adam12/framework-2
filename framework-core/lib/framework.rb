# frozen-string-literal: true

module Framework
  require_relative "framework/version"
  require_relative "framework/class_methods"
  require_relative "framework/variant"
  require_relative "framework/logger"
  require_relative "framework/errors"
  require_relative "framework/plugins"
  require_relative "framework/application"

  UNDEFINED = Object.new

  autoload :Validation, "framework/validation"
  autoload :Filter, "framework/filter"
end
