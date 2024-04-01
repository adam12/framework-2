module Framework
  module Middleware
    # Middleware to handle healthchecks by loadbalancers.
    class Up
      def initialize(app)
        @app = app
      end

      def call(env)
        return @app.call(env) unless env["PATH_INFO"] == "/up"

        response = Rack::Response.new
        response.status = 200
        response["content-type"] = "text/plain"
        response.write "UP"
        response.finish
      end
    end
  end
end
