# frozen-string-literal: true

module Framework
  module Plugins
    autoload :Core, __dir__ + "/plugins/core.rb"
    autoload :H, __dir__ + "/plugins/h.rb"
    autoload :HttpRouter, __dir__ + "/plugins/http_router.rb"
  end
end
