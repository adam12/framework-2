# frozen-string-literal: true

module Framework
  module Plugins
    module Http
      class Action
        @application_class = Framework::Application

        attr_reader :_request
        alias_method :request, :_request

        attr_reader :_response
        alias_method :response, :_response

        attr_reader :_application
        alias_method :application, :_application

        def routes
          _application.route_helpers
        end

        def application_class
          self.class.application_class
        end

        def self.inherited(subclass)
          super
          subclass.application_class = application_class
        end

        def self.===(other)
          name == other.name
        end

        module ActionMethods
          # Hook called before the call method in the action
          def before_call
          end

          # Hook called after the call method in the action
          def after_call(res)
            res
          end

          # Hook to customize error handling
          #
          # Override this inside the action to customize errors raised.
          def handle_error(ex)
            raise ex
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
            instance = build
            instance.instance_variable_set(:@_request, application_class::Request.new(env))
            instance.instance_variable_set(:@_response, application_class::Response.new)
            instance.instance_variable_set(:@_application, application_class.instance)

            catch(:halt) do
              instance.before_call
              res = instance.call
              instance.after_call(res)
            rescue Exception => ex # standard:disable Lint/RescueException
              instance.handle_error(ex)
            end
          end
        end

        extend ActionClassMethods
        include ActionMethods
      end
    end
  end
end
