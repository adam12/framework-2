# frozen-string-literal: true

require "rack"
require "hanami/router"

module Framework
  class Request < ::Rack::Request
    def params
      env["router.params"]
    end
  end

  class Response < ::Rack::Response
  end

  module Action
    def self.included(action)
      super

      action.class_eval do
        attr_reader :request
        attr_reader :response
        attr_reader :_application

        def routes
          _application.route_helpers
        end

        def _setup(application, env)
          @request = Framework::Request.new(env)
          @response = Framework::Response.new
          @_application = application
        end

        def self.call(application, env)
          new.tap do |obj|
            obj._setup(application, env)
          end.call
        end
      end
    end
  end

  class Application
    attr_reader :router
    attr_reader :route_helpers

    def initialize
    end

    def to_app
      @router
    end

    def setup(router)
      @router = router
      @route_helpers = RouteHelpers.new(router)
    end

    def self.namespace
      to_s.chomp("::Application")
    end

    def self.start
      new.tap do |application|
        resolver = Framework::Resolver.new(application)

        routes = Kernel.const_get(namespace)::Routes.routes
        router = Router.new(resolver: resolver, &routes)

        application.setup(router)
      end.to_app
    end
  end

  class Resolver
    def initialize(application)
      @application = application
    end

    def call(_path, to)
      return to unless to < Framework::Action

      # Provide application as first argument to call method
      to.method(:call).curry.call(@application)
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
