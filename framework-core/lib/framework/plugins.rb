# frozen-string-literal: true

module Framework
  module Plugins
    autoload :Core, __dir__ + "/plugins/core.rb"
    autoload :Loader, __dir__ + "/plugins/loader.rb"
    autoload :Variant, __dir__ + "/plugins/variant.rb"
  end
end
