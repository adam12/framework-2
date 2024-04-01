module Framework
  module Plugins
    module Core
      module ApplicationInstanceMethods
        attr_reader :namespace
        attr_reader :config

        def initialize(namespace, config)
          @namespace = namespace
          @config = config
        end

        # Hook called after construction of application instance
        #
        # Override and call `super`.
        def after_initialize
        end
      end

      module ApplicationClassMethods
        def namespace
          Utils.constantize(Utils.deconstantize(to_s))
        end

        def build(namespace: nil)
          namespace ||= self.namespace
          instance = new(namespace, config.dup)
          instance.after_initialize
          instance
        end

        def app
          instance
        end

        def root
          Framework.root
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
