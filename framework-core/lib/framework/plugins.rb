# frozen-string-literal: true

module Framework
  module Plugins
    autoload :Core, __dir__ + "/plugins/core.rb"
    autoload :Loader, __dir__ + "/plugins/loader.rb"
    autoload :Variant, __dir__ + "/plugins/variant.rb"
    autoload :Initializers, __dir__ + "/plugins/initializers.rb"
    autoload :Settings, __dir__ + "/plugins/settings"
  end
end
