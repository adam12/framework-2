module Framework
  module Plugins
    module Core
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

        def root
          Framework.root
        end
      end

      def self.before_load(mod)
        mod.class_eval do
          extend ApplicationClassMethods
        end
      end
    end
  end
end
