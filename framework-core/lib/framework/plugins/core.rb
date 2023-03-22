module Framework
  module Plugins
    module Core
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
      end

      module ActionClassMethods
        attr_accessor :application_class

        def build(env)
          new.tap do |instance|
            instance._request = application_class::FrameworkRequest.new(env)
            instance._response = application_class::FrameworkResponse.new
          end
        end

        def call(env)
          catch(:halt) do
            build(env).call
          end
        end

        def inspect
          "#{application_class.inspect}::FrameworkAction"
        end

        def inherited(mod)
          super
          mod.application_class = application_class
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

        mod::FrameworkRequest.extend(RequestClassMethods)
        mod::FrameworkResponse.include(ResponseMethods)
        mod::FrameworkResponse.extend(ResponseClassMethods)
        mod::FrameworkAction.include(ActionMethods)
        mod::FrameworkAction.extend(ActionClassMethods)
      end
    end
  end
end
