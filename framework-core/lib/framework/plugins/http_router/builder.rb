# frozen-string-literal: true

require "rack/builder"

module Framework
  module Plugins
    module HttpRouter
      class Builder
        attr_accessor :middleware_stack
        attr_accessor :router

        def initialize(middleware_stack, router)
          @middleware_stack = middleware_stack
          @router = router
        end

        def to_app
          Rack::Builder.new.tap do |builder|
            middleware_stack.each do |middleware, opts|
              builder.use middleware, *opts
            end

            builder.run router
          end.to_app
        end
      end
    end
  end
end
