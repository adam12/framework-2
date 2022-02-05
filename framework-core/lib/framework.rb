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
          self
        end

        def self.call(application, env)
          new._setup(application, env).call
        end
      end
    end
  end

  class Application
    attr_reader :router
    attr_reader :route_helpers
    attr_reader :namespace
    attr_reader :base_url

    def initialize(namespace, base_url)
      @namespace = namespace
      @base_url = base_url
      setup_router
    end

    def to_app
      @router
    end

    def self.build(base_url: nil)
      new(namespace, base_url)
    end

    def self.start(...)
      build(...).to_app
    end

    def self.namespace
      to_s.chomp("::Application")
    end

    private

    def setup_router
      @router = Framework::Router.build(self)
      @route_helpers = Framework::RouteHelpers.new(router)
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
    def self.build(application)
      resolver = Framework::Resolver.new(application)
      routes = Kernel.const_get(application.namespace)::Routes.routes
      new(base_url: application.base_url, resolver: resolver, &routes)
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
