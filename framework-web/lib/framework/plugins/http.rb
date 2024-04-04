# frozen-string-literal: true

require "rack"

module Framework
  module Plugins
    module Http
      # Request instance passed inside action
      class Request < ::Rack::Request
      end

      # Response instance inside action
      class Response < ::Rack::Response
        # Immediately halt request with provided response
        #
        #   response.halt(200)
        #   response.halt("This is the body")
        #   response.halt(200, "This is the body")
        def halt(*res)
          case res
          in [Integer => status]
            self.status = status
          in [String => body]
            write(body)
          in [Integer => status, String => body]
            self.status = status
            write(body)
          end

          throw :halt, finish
        end
      end

      class Action
        @application_class = Framework::Application

        attr_reader :_request
        alias_method :request, :_request

        attr_reader :_response
        alias_method :response, :_response

        def _application
          application_class.instance
        end
        alias_method :application, :_application

        def routes
          _application.route_helpers
        end

        def application_class
          self.class.application_class
        end

        # Hook to customize error handling
        #
        # Override this inside the action to customize errors raised.
        def handle_error(ex)
          raise ex
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
          # Accept call with request_context and then invoke Action's `call`
          # method without any arguments.
          def call(env)
            @_request = application_class::Request.new(env)
            @_response = application_class::Response.new

            catch(:halt) do
              around_call do
                # Intentionally called without arguments
                super()
              end
            rescue Exception => ex # standard:disable Lint/RescueException
              handle_error(ex)
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

          # Entrypoint
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
