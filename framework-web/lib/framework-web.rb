module Framework
  module Plugins
    autoload :H, __dir__ + "/framework/plugins/h.rb"
    autoload :Http, __dir__ + "/framework/plugins/http.rb"
    autoload :HttpRouter, __dir__ + "/framework/plugins/http_router.rb"
    autoload :HttpSession, __dir__ + "/framework/plugins/http_session.rb"
    autoload :HttpFlash, __dir__ + "/framework/plugins/http_flash.rb"
    autoload :HttpCsrf, __dir__ + "/framework/plugins/http_csrf.rb"
    autoload :RenderResponse, __dir__ + "/framework/plugins/render_response.rb"
  end

  module Middleware
    autoload :AssumeSsl, __dir__ + "/framework/middleware/assume_ssl.rb"
    autoload :Up, __dir__ + "/framework/middleware/up"
  end

  autoload :Resolver, __dir__ + "/framework/web/resolver.rb"
end
