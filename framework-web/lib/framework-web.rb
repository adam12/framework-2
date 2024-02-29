module Framework
  module Plugins
    autoload :H, __dir__ + "/framework/plugins/h.rb"
    autoload :Http, __dir__ + "/framework/plugins/http.rb"
    autoload :HttpRouter, __dir__ + "/framework/plugins/http_router.rb"
  end
end
