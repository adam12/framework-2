module Framework
  module Plugins
    # Add `variant` class method to applications.
    #
    # ## Example
    #   class Application < Framework::Application
    #     plugin Framework::Plugins::Variant
    #
    #     if variant.development?
    #       # Do something only in development
    #     end
    #   end
    module Variant
      def self.before_load(application)
        application.extend ApplicationClassMethods
      end

      module ApplicationClassMethods
        # Returns an instance of `Framework::Variant` for further chanining.
        #
        # ## Examples
        #   variant              # => Framework::Variant
        #   variant.development? # => true
        #   variant.default      # => :development
        def variant
          @variant ||= Framework::Variant
        end
      end
    end
  end
end
