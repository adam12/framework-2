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

      # TODO: Move all these to the plugins themselves

      mod.after_load(self, ...) if mod.respond_to?(:after_load)
    end

    plugin(Framework::Plugins::Core)
  end
end
