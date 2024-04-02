module Framework
  module Plugins
    module Core
      module ApplicationInstanceMethods
        attr_reader :config

        def initialize(config)
          @config = config
        end

        # Hook called after construction of application instance
        #
        # Override and call `super`.
        def after_initialize
        end

        # Namespace of Application class
        #
        # See Application.namespace.
        def namespace
          self.class.namespace
        end
      end

      module ApplicationClassMethods
        def build
          instance = new(config.dup)
          instance.after_initialize
          instance
        end

        def app
          instance
        end

        def root
          Framework.root
        end

        # Namespace of Application class
        #
        # Uses module above Application class if available, or an anonymous
        # module if not.
        def namespace
          return @namespace if defined?(@namespace)

          @namespace = if name
            Utils::String.constantize(Utils::String.deconstantize(name))
          else
            # Anonymous class
            Module.new
          end
        end

        # Singleton instance of built application
        def instance
          @instance ||= build
        end
      end

      def self.before_load(mod)
        require "framework/utils"

        mod.class_eval do
          include ApplicationInstanceMethods
          extend ApplicationClassMethods
        end
      end
    end
  end
end
