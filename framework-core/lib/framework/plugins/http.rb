# frozen-string-literal: true

require "rack"

module Framework
  module Plugins
    module Http
      class HttpRequest < ::Rack::Request
        @application_class = Framework::Application

        def self.inherited(subclass)
          super
          subclass.application_class = application_class
        end

        class << self
          attr_accessor :application_class
        end
      end

      class HttpResponse < ::Rack::Response
        @application_class = Framework::Application

        def self.inherited(subclass)
          super
          subclass.application_class = application_class
        end

        class << self
          attr_accessor :application_class
        end
      end

      class HttpAction
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
        end

        class << self
          attr_accessor :application_class

          def build(env)
            new.tap do |instance|
              instance._request = application_class::HttpRequest.new(env)
              instance._response = application_class::HttpResponse.new
            end
          end

          def call(env)
            catch(:halt) do
              build(env).call
            end
          end
        end
      end

      def self.before_load(mod)
        request = Class.new(HttpRequest)
        request.application_class = mod
        mod.const_set(:HttpRequest, request)

        response = Class.new(HttpResponse)
        response.application_class = mod
        mod.const_set(:HttpResponse, response)

        action = Class.new(HttpAction)
        action.application_class = mod
        mod.const_set(:HttpAction, action)
      end
    end
  end
end
