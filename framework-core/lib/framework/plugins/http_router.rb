# frozen-string-literal: true

module Framework
  module Plugins
    module HttpRouter
      require_relative "http_router/middleware_stack"
      require_relative "http_router/builder"

      module ApplicationInstanceMethods
        attr_accessor :router
        attr_accessor :route_helpers
        attr_accessor :http_middleware

        def to_app
          Builder.new(http_middleware, router).to_app
        end
      end

      module ApplicationClassMethods
        def build(base_url: nil)
          config = self.config.dup
          config.http_router.base_url = base_url

          instance = new(namespace, config)
          instance.router = router = Framework::Router.build(instance)
          instance.route_helpers = Framework::RouteHelpers.new(router)
          instance.http_middleware = config.http_router.middleware
          instance
        end

        def start(...)
          build(...).to_app
        end
      end

      def self.before_load(mod)
        require "framework/router"
        require "framework/route_helpers"

        mod.class_eval do
          include ApplicationInstanceMethods
          extend ApplicationClassMethods

          setting :http_router do
            setting :base_url
            setting :middleware, default: MiddlewareStack.default
          end
        end
      end
    end
  end
end
