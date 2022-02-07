# frozen-string-literal: true

require "rack"
require "hanami/router"
require "dry-configurable"

module Framework
  module Errors
    Error = Class.new(StandardError)
  end

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
        attr_reader :_request
        alias_method :request, :_request

        attr_reader :_response
        alias_method :response, :_response

        attr_reader :_application

        def routes
          _application.route_helpers
        end

        def _setup(application, env)
          # Use the application's FrameworkRequest and FrameworkResponse classes
          @_request = application.class::FrameworkRequest.new(env)
          @_response = application.class::FrameworkResponse.new
          @_application = application
          self
        end

        def self.call(application, env)
          new._setup(application, env).call
        end
      end
    end
  end

  module Configurable
    def self.extended(base)
      base.extend Dry::Configurable
    end
  end

  class Application
    attr_reader :router
    attr_reader :route_helpers
    attr_reader :namespace
    attr_reader :config

    extend Framework::Configurable
    setting :base_url
    setting :body_parser, default: true

    def initialize(namespace, config)
      @namespace = namespace
      @config = config
      setup_router
    end

    def to_app
      Rack::Builder.new.tap do |builder|
        if config.body_parser
          require "hanami/middleware/body_parser"
          builder.use Hanami::Middleware::BodyParser, :json
        end

        builder.run self.router
      end.to_app
    end

    def self.build(base_url: nil)
      config = self.config.dup
      config.base_url = base_url
      new(namespace, config)
    end

    def self.start(...)
      build(...).to_app
    end

    def self.namespace
      to_s.chomp("::Application")
    end

    def self.inherited(application)
      super

      # Define the FrameworkRequest and FrameworkResponse classes inside the application namespace
      application.const_set(:FrameworkRequest, Class.new(Framework::Request))
      application.const_set(:FrameworkResponse, Class.new(Framework::Response))
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
      begin
        route_class = Kernel.const_get(application.namespace)::Routes
      rescue NameError
        raise Errors::Error, <<~EOM
          Unable to find routes in '#{application.namespace}::Routes'. Try defining routes first.

            module #{application.namespace}
              class Routes < Framework::Routes
                define do
                  get "/", to: YourAction
                end
              end
            end
        EOM
      end

      new(base_url: application.config.base_url, resolver: resolver, &route_class.routes)
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
