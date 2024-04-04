# frozen-string-literal: true

module Framework
  module Plugins
    module HttpRouter
      require_relative "http_router/middleware_stack"
      require_relative "http_router/builder"
      require_relative "http_router/route_helpers"

      module RequestMethods
        def params
          @params ||= Rack::Request.new(env).params.merge(env["router.params"])
        end
      end

      module ApplicationInstanceMethods
        attr_accessor :router
        attr_accessor :route_helpers
        attr_accessor :http_middleware

        def to_app
          Builder.new(http_middleware, router).to_app
        end

        def after_initialize
          super

          self.router = Framework::Router.build(self)
          self.route_helpers = RouteHelpers.new(router)
          self.http_middleware = self.class.settings[:http_router][:middleware]
        end
      end

      module ApplicationClassMethods
        def start(...)
          build(...).to_app
        end
      end

      def self.before_load(mod)
        mod.plugin Framework::Plugins::Http

        require "framework/web/router"

        mod::Request.include(RequestMethods)

        mod.class_eval do
          include ApplicationInstanceMethods
          extend ApplicationClassMethods

          settings[:http_router] ||= {}
          settings[:http_router][:base_url] = "http://localhost"
          settings[:http_router][:middleware] = MiddlewareStack.default
        end
      end
    end
  end
end
