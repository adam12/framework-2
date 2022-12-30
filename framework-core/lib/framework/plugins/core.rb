module Framework
  module Plugins
    module Core
      module RequestMethods
        def params
          @params ||= Rack::Request.new(env).params.merge(env["router.params"])
        end
      end

      module RequestClassMethods
        attr_accessor :application_class

        def inspect
          "#{application_class.inspect}::FrameworkRequest"
        end
      end

      module ResponseMethods
      end

      module ResponseClassMethods
        attr_accessor :application_class

        def inspect
          "#{application_class.inspect}::FrameworkResponse"
        end
      end

      module ActionMethods
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
      end

      module ActionClassMethods
        attr_accessor :application_class

        def call(application, env)
          catch(:halt) do
            new._setup(application, env).call
          end
        end

        def inspect
          "#{application_class.inspect}::FrameworkAction"
        end
      end

      module ApplicationClassMethods
        def build
          new(
            namespace,
            config.dup
          )
        end

        def app
          @app = build
        end
      end

      def self.before_load(mod)
        mod.class_eval do
          extend ApplicationClassMethods
        end
      end
    end
  end
end
