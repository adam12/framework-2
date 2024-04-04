module Framework
  module Plugins
    module Settings
      module ApplicationClassMethods
        def settings
          @settings ||= {}
        end

        def inherited(subclass)
          super
          settings.replace(Settings.deep_clone(settings))
        end
      end

      module ApplicationInstanceMethods
        def settings
          self.class.settings
        end
      end

      def self.deep_clone(obj)
        Marshal.load(Marshal.dump(obj))
      end

      def self.before_load(mod)
        mod.class_eval do
          include ApplicationInstanceMethods
          extend ApplicationClassMethods
        end
      end
    end
  end
end
