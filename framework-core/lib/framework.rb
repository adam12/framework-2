# frozen-string-literal: true

require "rack"
require "hanami/router"
require "dry-configurable"
require_relative "framework/plugins/core"

module Framework
  module Errors
    Error = Class.new(StandardError)
  end

  module Configurable
    def self.extended(base)
      base.extend Dry::Configurable
    end
  end

  class Application
    class FrameworkRequest < ::Rack::Request
      @application_class = Framework::Application
    end

    class FrameworkResponse < ::Rack::Response
      @application_class = Framework::Application
    end

    class FrameworkAction
      @application_class = Framework::Application
    end

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

        builder.run router
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
      request = Class.new(self::FrameworkRequest)
      request.application_class = application
      application.const_set(:FrameworkRequest, request)

      response = Class.new(self::FrameworkResponse)
      response.application_class = application
      application.const_set(:FrameworkResponse, response)

      action = Class.new(self::FrameworkAction)
      action.application_class = application
      application.const_set(:FrameworkAction, action)
    end

    def self.plugin(mod, ...)
      mod.before_load(self, ...) if mod.respond_to?(:before_load)

      if defined?(mod::RequestMethods)
        self::FrameworkRequest.include(mod::RequestMethods)
      end

      if defined?(mod::RequestClassMethods)
        self::FrameworkRequest.extend(mod::RequestClassMethods)
      end

      if defined?(mod::ResponseMethods)
        self::FrameworkResponse.include(mod::ResponseMethods)
      end

      if defined?(mod::ResponseClassMethods)
        self::FrameworkResponse.extend(mod::ResponseClassMethods)
      end

      if defined?(mod::ActionMethods)
        self::FrameworkAction.include(mod::ActionMethods)
      end

      if defined?(mod::ActionClassMethods)
        self::FrameworkAction.extend(mod::ActionClassMethods)
      end

      mod.after_load(self, ...) if mod.respond_to?(:after_load)
    end

    plugin(Framework::Plugins::Core)

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
      return to unless to < Framework::Application::FrameworkAction

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

  class Router
    def initialize(base_url:, resolver:, &blk)
      @router = Hanami::Router.new(base_url: base_url, resolver: resolver)
      instance_eval(&blk) if blk
    end

    def self.build(application)
      resolver = Framework::Resolver.new(application)
      begin
        route_class = Kernel.const_get(application.namespace)::Routes
      rescue NameError
        # Define empty routes class if none has been defined
        Kernel.const_get(application.namespace).const_define(:Routes, Class.new(Framework::Routes))
      end

      new(base_url: application.config.base_url, resolver: resolver, &route_class.routes)
    end

    def get(path, to: nil, as: nil, **constraints, &blk)
      @router.get(path, to: to, as: as, **constraints, &blk)
    end

    def post(path, to: nil, as: nil, **constraints, &blk)
      @router.post(path, to: to, as: as, **constraints, &blk)
    end

    def patch(path, to: nil, as: nil, **constraints, &blk)
      @router.patch(path, to: to, as: as, **constraints, &blk)
    end

    def put(path, to: nil, as: nil, **constraints, &blk)
      @router.put(path, to: to, as: as, **constraints, &blk)
    end

    def delete(path, to: nil, as: nil, **constraints, &blk)
      @router.delete(path, to: to, as: as, **constraints, &blk)
    end

    def link(path, to: nil, as: nil, **constraints, &blk)
      @router.link(path, to: to, as: as, **constraints, &blk)
    end

    def unlink(path, to: nil, as: nil, **constraints, &blk)
      @router.unlink(path, to: to, as: as, **constraints, &blk)
    end

    def options(path, to: nil, as: nil, **constraints, &blk)
      @router.options(path, to: to, as: as, **constraints, &blk)
    end

    def trace(path, to: nil, as: nil, **constraints, &blk)
      @router.trace(path, to: to, as: as, **constraints, &blk)
    end

    def mount(app, at:, **constraints)
      @router.mount(app, at: at, **constraints)
    end

    def redirect(path, to: nil, as: nil, code: DEFAULT_REDIRECT_CODE)
      @router.redirect(path, to: to, as: as, code: code)
    end

    def scope(path, &blk)
      @router.scope(path, &blk)
    end

    def root(to: nil, &blk)
      @router.root(to: to, &blk)
    end

    def path(...)
      @router.path(...)
    end

    def url(...)
      @router.url(...)
    end

    def call(...)
      @router.call(...)
    end

    DEFAULT_REDIRECT_CODE = 301
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
