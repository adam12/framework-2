# frozen-string-literal: true

require "rack"
require_relative "configurable"
require_relative "utils"

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

    attr_reader :namespace
    attr_reader :config

    extend Framework::Configurable

    def initialize(namespace, config)
      @namespace = namespace
      @config = config
    end

    def self.namespace
      Utils.deconstantize(to_s)
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
    plugin(Framework::Plugins::HttpRouter)
  end
end
