module Framework
  module Plugins
    module HttpCsrf
      def self.before_load(application, **)
        require "rack/csrf"

        application.config.http_router.middleware.use ::Rack::Csrf, **
      end

      module ActionMethods
        def csrf_tag
          ::Rack::Csrf.tag(request.env)
        end
      end
    end
  end
end
