# frozen-string-literal: true

module Framework
  class Resolver
    class RequestContext
      def self.build(env:, application:)
        request = application.class::Request.new(env)
        response = application.class::Response.new

        new(env:, application:, request:, response:)
      end

      attr_accessor :env
      attr_accessor :application
      attr_accessor :request
      attr_accessor :response

      def initialize(env:, application:, request:, response:)
        @env = env
        @application = application
        @request = request
        @response = response
      end
    end

    def initialize(application)
      @application = application
    end

    def call(_path, to)
      if to < Framework::Plugins::Http::Action
        ->(env) {
          request_context = RequestContext.build(env: env, application: @application)
          to.call(request_context)
        }
      else
        to
      end
    end
  end
end
