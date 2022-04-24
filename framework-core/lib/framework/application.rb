# frozen-string-literal: true

require "rack"
require_relative "configurable"
require_relative "router"
require_relative "route_helpers"
require_relative "plugins/core"

module Framework
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
end
