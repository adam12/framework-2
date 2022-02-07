module Framework
  module Plugins
    module Core
      module RequestMethods
        def params
          env["router.params"]
        end
      end

      module RequestClassMethods
        attr_accessor :application_class
      end

      module ResponseMethods
      end

      module ResponseClassMethods
        attr_accessor :application_class
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
          new._setup(application, env).call
        end
      end
    end
  end
end
