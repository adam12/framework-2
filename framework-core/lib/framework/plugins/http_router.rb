# frozen-string-literal: true

module Framework
  module Plugins
    class HttpRouter
      module ApplicationClassMethods
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

      def self.before_load(mod)
        require "rack"

        mod.include ApplicationClassMethods

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
