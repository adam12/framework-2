# frozen-string-literal: true
require "hanami/router"

module Framework
  module Action
    def self.included(action)
      super

      action.class_eval do
        attr_accessor :request
        attr_accessor :response

        def self.call(env)
          new.tap do |obj|
            obj.request = Rack::Request.new(env)
            obj.response = Rack::Response.new
          end.call
        end
      end
    end
  end

  class Application
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def to_app
      @router
    end

    def self.namespace
      to_s.chomp("::Application")
    end

    def self.start
      routes = Kernel.const_get(namespace)::Routes.routes
      router = Router.new(&routes)
      new(router).to_app
    end
  end

  class Router < ::Hanami::Router
  end

  class Routes
    def self.define(&blk)
      @routes = blk
    end

    def self.routes
      @routes || proc {}
    end
  end
end
