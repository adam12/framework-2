# frozen-string-literal: true

module Framework
  module Plugins
    class HttpRouter
      def self.before_load(mod)
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
