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
      end

      module ApplicationClassMethods
        def namespace
          Utils.deconstantize(to_s)
        end

        def build(namespace: nil)
          namespace ||= self.namespace
          new(namespace, config.dup)
        end

        def app
          @app = build
        end

        def root
          Framework.root
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
