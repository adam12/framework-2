# frozen-string-literal: true

require "rack"
require "hanami/router"

module Framework
  class Request < ::Rack::Request
    def params
      env["router.params"]
    end

    def route_helpers
      env[Router::HELPERS_KEY]
    end
  end

  class Response < ::Rack::Response
  end

  module Action
    def self.included(action)
      super

      action.class_eval do
        attr_accessor :request
        attr_accessor :response

        def routes
          request.route_helpers
        end

        def self.call(env)
          new.tap do |obj|
            obj.request = Framework::Request.new(env)
            obj.response = Framework::Response.new
          end.call
        end
      end
    end
  end

  class Application
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def to_app
      @router
    end

    def self.namespace
      to_s.chomp("::Application")
    end

    def self.start
      routes = Kernel.const_get(namespace)::Routes.routes
      router = Router.new(&routes)
      new(router).to_app
    end
  end

  class RouteHelpers
    def initialize(router)
      @router = router
    end

    def path(...)
      @router.path(...)
    end

    def url(...)
      @router.url(...)
    end
  end

  class Router < ::Hanami::Router
    HELPERS_KEY = "router.helpers"

    def call(env)
      env[HELPERS_KEY] = Framework::RouteHelpers.new(self)
      super
    end
  end

  class Routes
    def self.define(&blk)
      @routes = blk
    end

    def self.routes
      @routes || proc {}
    end
  end
end
