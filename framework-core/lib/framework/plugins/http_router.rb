# frozen-string-literal: true

module Framework
  module Plugins
    class HttpRouter
      module ApplicationInstanceMethods
        attr_accessor :router
        attr_accessor :route_helpers

        def to_app
          Rack::Builder.new.tap do |builder|
            if config.body_parser
              require "hanami/middleware/body_parser"
              builder.use Hanami::Middleware::BodyParser, :json
            end

            builder.run router
          end.to_app
        end
      end

      module ApplicationClassMethods
        def build(base_url: nil)
          config = self.config.dup
          config.base_url = base_url

          instance = new(namespace, config)
          instance.router = router = Framework::Router.build(instance)
          instance.route_helpers = Framework::RouteHelpers.new(router)
          instance
        end

        def start(...)
          build(...).to_app
        end
      end

      def self.before_load(mod)
        require "rack"
        require "framework/router"
        require "framework/route_helpers"

        mod.class_eval do
          include ApplicationInstanceMethods
          extend ApplicationClassMethods

          setting :base_url
          setting :body_parser, default: true
        end
      end
    end
  end
end
