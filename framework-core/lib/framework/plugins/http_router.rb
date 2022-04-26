# frozen-string-literal: true

module Framework
  module Plugins
    class HttpRouter
      module ApplicationInstanceMethods
        def to_app
          Rack::Builder.new.tap do |builder|
            if config.body_parser
              require "hanami/middleware/body_parser"
              builder.use Hanami::Middleware::BodyParser, :json
            end

            builder.run router
          end.to_app
        end

        def setup_router
          @router = Framework::Router.build(self)
          @route_helpers = Framework::RouteHelpers.new(router)
        end
      end

      module ApplicationClassMethods
        def build(base_url: nil)
          config = self.config.dup
          config.base_url = base_url
          instance = new(namespace, config)
          instance.setup_router
          instance
        end

        def start(...)
          build(...).to_app
        end
      end

      def self.before_load(mod)
        require "rack"

        mod.include ApplicationInstanceMethods
        mod.extend ApplicationClassMethods

        mod.class_eval do
          attr_reader :router
          attr_reader :route_helpers

          setting :base_url
          setting :body_parser, default: true
        end
      end
    end
  end
end
