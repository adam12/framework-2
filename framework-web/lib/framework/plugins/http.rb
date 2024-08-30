# frozen-string-literal: true

require "rack"
require_relative "http/request"
require_relative "http/response"
require_relative "http/action"

module Framework
  module Plugins
    module Http
      module ApplicationClassMethods
        def load_plugin(application, mod)
          if defined?(mod::RequestMethods)
            application::Request.include(mod::RequestMethods)
          end

          if defined?(mod::RequestClassMethods)
            application::Request.extend(mod::RequestClassMethods)
          end

          if defined?(mod::ResponseMethods)
            application::Response.include(mod::ResponseMethods)
          end

          if defined?(mod::ResponseClassMethods)
            application::Response.extend(mod::ResponseClassMethods)
          end

          if defined?(mod::ActionMethods)
            application::Action.include(mod::ActionMethods)
          end

          if defined?(mod::ActionClassMethods)
            application::Action.extend(mod::ActionClassMethods)
          end

          super
        end
      end

      def self.before_load(mod)
        mod.extend(ApplicationClassMethods)

        request = Class.new(Request)
        mod.const_set(:Request, request)

        response = Class.new(Response)
        mod.const_set(:Response, response)

        action = Class.new(Action)
        action.application_class = mod
        mod.const_set(:Action, action)
      end
    end
  end
end
