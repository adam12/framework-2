module Framework
  module Middleware
    class AssumeSsl
      def initialize(app)
        @app = app
      end

      def call(env)
        env["HTTPS"] = "on"
        env["HTTP_X_FORWARDED_PORT"] = 443
        env["HTTP_X_FORWARDED_PROTO"] = "https"
        env["rack.url_scheme"] = "https"

        @app.call(env)
      end
    end
  end
end
