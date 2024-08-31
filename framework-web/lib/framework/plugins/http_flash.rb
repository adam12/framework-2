module Framework
  module Plugins
    module HttpFlash
      # :nodoc:
      # FlashHash implementation borrowed from github.com/jeremyevans/roda
      # :doc
      class FlashHash < DelegateClass(Hash)
        attr_reader :next

        def initialize(hash)
          @next = {}
          super
        end

        alias_method :now, :__getobj__

        def []=(key, value)
          @next[key] = value
        end

        def sweep
          replace(@next)
          @next.clear
          self
        end
      end

      module ActionMethods
        def flash
          request.env["_flash"]
        end
      end

      class Middleware
        def initialize(app, opts = {})
          @app = app
          @opts = opts
        end

        def call(env)
          env["_flash"] = flash = FlashHash.new(env["rack.session"]["_flash"] ||= {})

          res = @app.call(env)

          flash.sweep

          res
        end
      end

      def self.before_load(application)
        application.settings[:http_router][:middleware].use Middleware
      end
    end
  end
end
