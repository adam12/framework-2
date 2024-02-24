# frozen-string-literal: true

module Framework
  module Plugins
    autoload :Core, __dir__ + "/plugins/core.rb"
    autoload :H, __dir__ + "/plugins/h.rb"
    autoload :Http, __dir__ + "/plugins/http.rb"
    autoload :HttpRouter, __dir__ + "/plugins/http_router.rb"
    autoload :Loader, __dir__ + "/plugins/loader.rb"
  end
end
