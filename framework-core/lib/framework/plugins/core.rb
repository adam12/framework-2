# frozen-string-literal: true

module Framework
  module Plugins
    # Core framework functionality.
    #
    # Automatically loaded into framework. Manually adding using `plugin` is not
    # necessary.
    module Core
      module ApplicationInstanceMethods
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
        # Empty method to customize startup process
        def start
        end

        # Empty method to customize initialization process
        def build(...)
          new(...)
        end

        # :nodoc:
        # Ensure that all new instances have `after_initialize` called upon
        # them.
        # :doc:
        def new(...)
          super.tap do |instance|
            instance.after_initialize
          end
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
        mod.plugin Settings

        mod.class_eval do
          include ApplicationInstanceMethods
          extend ApplicationClassMethods
        end
      end
    end
  end
end
