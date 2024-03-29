module Framework
  module Plugins
    # Add `variant` class method to applications
    module Variant
      def self.before_load(application)
        application.extend ApplicationClassMethods
      end

      module ApplicationClassMethods
        def variant
          @variant ||= Framework::Variant
        end
      end
    end
  end
end
