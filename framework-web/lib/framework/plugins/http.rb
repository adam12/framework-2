# frozen-string-literal: true

require "rack"

module Framework
  module Plugins
    module Http
      class Request < ::Rack::Request
        @application_class = Framework::Application

        def self.inherited(subclass)
          super
          subclass.application_class = application_class
        end

        class << self
          attr_accessor :application_class
        end
      end

      class Response < ::Rack::Response
        @application_class = Framework::Application

        def self.inherited(subclass)
          super
          subclass.application_class = application_class
        end

        class << self
          attr_accessor :application_class
        end
      end

      class Action
        @application_class = Framework::Application

        attr_accessor :_request
        alias_method :request, :_request

        attr_accessor :_response
        alias_method :response, :_response

        def routes
          application_class.app.route_helpers
        end

        def application_class
          self.class.application_class
        end

        def self.inherited(subclass)
          super
          subclass.application_class = application_class
          subclass.prepend Callable
        end

        def self.===(other)
          name == other.name
        end

        module Callable
          # Set up instance method that accepts env, request, response
          # and calls method inside Action without any arguments.
          def call(env, request = nil, response = nil)
            catch(:halt) do
              @env = env
              @_request = request || application_class::Request.new(env)
              @_response = response || application_class::Response.new

              around_call do
                super()
              end
            end
          end
        end

        module ActionMethods
          # Hook to allow mutating of return value from Action `call` method.
          def around_call
            yield
          end
        end

        module ActionClassMethods
          attr_accessor :application_class

          # Hook to allow customization of action construction and pass
          # dependencies.
          def build
            new
          end

          # Entrypoint as a Rack-style application.
          def call(env)
            build.call(env)
          end
        end

        extend ActionClassMethods
        include ActionMethods
      end

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
        request.application_class = mod
        mod.const_set(:Request, request)

        response = Class.new(Response)
        response.application_class = mod
        mod.const_set(:Response, response)

        action = Class.new(Action)
        action.application_class = mod
        mod.const_set(:Action, action)
      end
    end
  end
end
