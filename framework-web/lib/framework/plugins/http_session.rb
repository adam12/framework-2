module Framework
  module Plugins
    module HttpSession
      def self.before_load(application, secret: ENV.fetch("SESSION_SECRET"))
        application.settings[:http_router][:middleware].use ::Rack::Session::Cookie, secret: secret
      end

      module ActionMethods
        def session
          request.env["rack.session"]
        end
      end
    end
  end
end
